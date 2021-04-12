-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 12, 2021 at 07:20 AM
-- Server version: 8.0.23-0ubuntu0.20.04.1
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `205cde`
--

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `id` int NOT NULL,
  `orderTime` datetime NOT NULL,
  `product_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`id`, `orderTime`, `product_id`, `user_id`) VALUES
(4, '2021-04-11 01:16:22', 1, 2),
(5, '2021-04-11 01:16:28', 3, 2),
(6, '2021-04-11 01:16:35', 4, 2),
(7, '2021-04-11 09:35:53', 5, 4),
(8, '2021-04-11 13:55:58', 1, 5),
(9, '2021-04-11 13:56:04', 3, 5);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `price` varchar(120) NOT NULL,
  `url_pic` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `price`, `url_pic`) VALUES
(1, 'hottoys ironman mark85', '2500', 'ironman_mark85.jpg'),
(3, 'hottoys ironman mark50', '2300', 'ironman_mark50.jpg'),
(4, 'Metal Build Exia', '1800', 'MB_Exia.jpg'),
(5, 'Metal Build 00R', '2300', 'MB_00R.jpg'),
(6, 'saya', '1300', 'saya.jpg'),
(7, 'teddy bear', '100', 'teddybear.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `product_specific`
--

CREATE TABLE `product_specific` (
  `id` int NOT NULL,
  `specific` text,
  `productId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `product_specific`
--

INSERT INTO `product_specific` (`id`, `specific`, `productId`) VALUES
(2, '1/6th scale Iron Man Mark LXXXV produced by hottoys\r\nIronman mark85 is the lasted armor of tony stark', 1),
(3, 'it is a cute bear', 7);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `is_super_user` tinyint(1) DEFAULT NULL,
  `username` varchar(80) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password` varchar(150) NOT NULL,
  `name` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `is_super_user`, `username`, `email`, `password`, `name`) VALUES
(1, 1, 'admin123', 'asd@asd.com', '$5$rounds=535000$mkUU1zSoKEKX4wvw$9gvML4ID5ac.5okViBKEejiGJxiWLKWMmo86AmvtYr2', 'admin'),
(2, 0, 'peter123', 'peter123@g.mail.com', '$5$rounds=535000$W5Gt3q4GMdrfrMpI$yCHAvlmt/P9bUzX0QmatJQL0SRBYgDVUnsnRHjt5X8A', 'peter123'),
(4, 0, 'amy123', 'amy@gmail.com', '$5$rounds=535000$0lj8f/.3Y6dtSRWX$QkNT5IhM4GYPIZPrxTHWiyu/JDTWWOgYmrOtzcNZAb0', 'amy'),
(5, 0, 'peter456', 'peter@gmail.com', '$5$rounds=535000$UoRoZvNcZ887tv8y$3P1Ia.bvci0.J8xmQNA5COztr7MalN9pmyVkwlDVt1D', 'peter');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_specific`
--
ALTER TABLE `product_specific`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `product_specific`
--
ALTER TABLE `product_specific`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `order_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `product_specific`
--
ALTER TABLE `product_specific`
  ADD CONSTRAINT `product_specific_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
