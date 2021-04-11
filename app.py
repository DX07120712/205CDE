from flask import Flask, render_template, flash, redirect, url_for, session, logging, request
from wtforms import Form, StringField, TextAreaField, PasswordField, validators
from passlib.hash import sha256_crypt
from flask_sqlalchemy import SQLAlchemy
from flask_admin import Admin,AdminIndexView
from flask_admin.contrib.sqla import ModelView
from datetime import datetime
from flask_admin.form.upload import ImageUploadField

# Config SQL
app = Flask(__name__)
app.secret_key = 'Project'

app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://admin:205CDE@localhost/205cde"
app.config["UPLOADED_IMAGES_DEST"] = imagedir ='static/images'

db = SQLAlchemy(app)



class User(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	is_super_user = db.Column(db.Boolean(),default=False)
	username = db.Column(db.String(80), unique=True, nullable=False)
	email = db.Column(db.String(120), unique=False, nullable=False)
	password = db.Column(db.String(150), unique=False, nullable=False)
	name =db.Column(db.String(80), unique=False, nullable=False)
	order_id = db.relationship('Order', backref='buyer',lazy=True)

class Product(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String(80), unique=False, nullable=False)
	price = db.Column(db.String(120), unique=False, nullable=False)
	product_specific_id = db.relationship('Product_specific', backref='product',lazy=True)
	url_pic = db.Column(db.String(150), nullable=False)
	order_id = db.relationship('Order', backref='product',lazy=True)

class Product_specific(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	specific = db.Column(db.Text(), unique=False, nullable=True)
	productId = db.Column(db.Integer, db.ForeignKey('product.id', ondelete='SET NULL'),nullable=True)

class Order(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	orderTime = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
	product_id = db.Column(db.Integer, db.ForeignKey('product.id', ondelete='SET NULL'),nullable=True)
	user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='SET NULL'),nullable=True)

#admin page 
class IndexView(AdminIndexView):
	def is_accessible(self):
		return (session["current_user"] and session['current_user']['superUser'])

	def inaccessible_callback(self,name,**kwarg):
		flash('please login as admin','danger')
		return redirect(url_for('login'))

class AllModelView(ModelView):
    can_delete = False
    page_size = 30

class ProductModelView(ModelView):

    column_list = [
        'id', 'name', 'price', 'product_specific_id','url_pic'
    ]


    form_extra_fields = {
        'url_pic': ImageUploadField(
            'Image',
            base_path=imagedir,
            url_relative_path='images/',
        )
    }


admin = Admin(app,index_view=IndexView())


admin.add_view(AllModelView(User,db.session))
admin.add_view(ProductModelView(Product,db.session))
admin.add_view(AllModelView(Product_specific,db.session))
admin.add_view(AllModelView(Order,db.session))

class RegisterForm(Form):
	name = StringField('Name', [validators.DataRequired(), validators.length(min=1, max=80)])
	username = StringField('Username', [validators.DataRequired(), validators.length(min=4, max=80)])
	email = StringField('Email', [validators.DataRequired(), validators.Email(), validators.length(min=6, max=120)])
	password = PasswordField('Password', [validators.DataRequired(), validators.EqualTo('confirm', message='Passwords must match')])
	confirm = PasswordField('Confirm Password')

class LoginForm(Form):
	username = StringField('Username', [validators.DataRequired()])
	password = PasswordField('Password', [validators.DataRequired()])


@app.route('/')
@app.route('/home')
def index():
	return render_template('home.html')

@app.route('/about')
def about():
	return render_template('about.html')

@app.route('/product')
def products():
	products = Product.query.all()
	return render_template('product.html', products = products)

@app.route('/product/<int:id>/')
def product(id):
	product = Product.query.filter_by(id=id).first()
	product_specific = Product_specific.query.filter_by(productId=product.id).first()
	return render_template('products.html',product=product, product_specific=product_specific)



@app.route('/register', methods=['GET', 'POST'])
def register():
	form = RegisterForm(request.form)
	if request.method == 'POST' and form.validate():
		name = form.name.data
		email = form.email.data
		username = form.username.data
		password = sha256_crypt.hash(str(form.password.data))

		#create cursor
		
		result = User.query.filter_by(username=username).first()
		if result:
			flash("The username is registered", 'danger')
		else:
			new_user = User(username=username,password=password,name=name,email=email)
			db.session.add(new_user)
			db.session.commit()
			flash("You are now registered and can log in", 'success')
			return redirect(url_for('index'))
	return render_template('register.html', form = form)



@app.route('/login', methods=['GET', 'POST'])
def login():
	form = LoginForm(request.form)
	if request.method == 'POST' and form.validate():
		username = form.username.data
		password_candidate = form.password.data

		result = User.query.filter_by(username=username).first()  

		if result:
			password = result.password

			if sha256_crypt.verify(password_candidate, password):
				session['current_user'] = {
					"username":username,
					"superUser": result.is_super_user
					}


				flash("Login Success", 'success')
				return redirect(url_for('index'))

			else:
				flash("PASSWORD NOT MATCHED", 'danger')
		else:
			flash('NO USER', 'danger')
	return render_template('login.html', form = form)


@app.route('/logout')
def logout():
	session.pop('current_user',None)
	print(session)
	return redirect(url_for('index'))

@app.route('/add', methods=['POST'])
def addOrder():
	try:
		if session['current_user']:
			productId = request.form.get('product-id')
			product = Product.query.filter_by(id=productId).first()
			user = User.query.filter_by(username=session['current_user']['username']).first()

			new_order = Order(product_id=product.id,user_id=user.id)
			db.session.add(new_order)
			db.session.commit()

			flash('You have ordered the product','success')
			return redirect(url_for('index'))
	except KeyError:
		flash('please login','danger')
		return redirect(url_for('login'))
    

	return redirect(request.referrer)

@app.route('/order', methods=['GET'])
def order():
	try:
		if session['current_user']:
			user = User.query.filter_by(username=session['current_user']['username']).first()
			orders = Order.query.filter_by(user_id=user.id).all()
			products = Product.query.all()
			

			return render_template('order.html',orders=orders,products=products,user=user)


	except KeyError:
		flash('please login','danger')
		return redirect(url_for('login'))

	return render_template('order.html')



if __name__ == '__main__':
	#db.create_all()
	app.run(debug = True)