-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 30, 2023 at 01:42 PM
-- Server version: 10.5.20-MariaDB
-- PHP Version: 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id21713436_socialrank`
--
CREATE DATABASE IF NOT EXISTS `socialrank` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `socialrank`;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `id` int(11) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `image` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`id`, `user_email`, `image`, `date`) VALUES
(38, 'ahmadkarim@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed31b6960b.jpg', '2023-12-29 14:09:31'),
(39, 'ahmadkarim@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed31f3584d.jpg', '2023-12-29 14:09:35'),
(40, 'karmajohn@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed37c14813.jpg', '2023-12-29 14:11:08'),
(41, 'karmajohn@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed3835c9a9.jpg', '2023-12-29 14:11:15'),
(42, 'peterparker@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed420a3638.jpg', '2023-12-29 14:13:52'),
(43, 'peterparker@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed4266911d.jpg', '2023-12-29 14:13:58'),
(44, 'tonystark@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed4918036c.jpg', '2023-12-29 14:15:45'),
(45, 'tonystark@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed4944bea9.jpg', '2023-12-29 14:15:48'),
(46, 'thebutiful@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed53ed8adc.jpg', '2023-12-29 14:18:38'),
(47, 'thebutiful@gmail.com', 'https://socialrankbysalam.000webhostapp.com/uploads/658ed5410664c.jpg', '2023-12-29 14:18:41');

-- --------------------------------------------------------

--
-- Table structure for table `rating`
--

CREATE TABLE `rating` (
  `id` int(50) NOT NULL,
  `rateduser_email` varchar(50) NOT NULL,
  `ratinguser_email` varchar(50) NOT NULL,
  `value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rating`
--

INSERT INTO `rating` (`id`, `rateduser_email`, `ratinguser_email`, `value`) VALUES
(14, 'ahmadkarim@gmail.com', 'karmajohn@gmail.com', 6.5),
(15, 'karmajohn@gmail.com', 'peterparker@gmail.com', 6.5),
(16, 'ahmadkarim@gmail.com', 'peterparker@gmail.com', 6.5),
(17, 'ahmadkarim@gmail.com', 'tonystark@gmail.com', 5.5),
(18, 'karmajohn@gmail.com', 'tonystark@gmail.com', 9),
(19, 'peterparker@gmail.com', 'tonystark@gmail.com', 3),
(20, 'thebutiful@gmail.com', 'karmajohn@gmail.com', 8),
(21, 'thebutiful@gmail.com', 'tonystark@gmail.com', 8),
(22, 'tonystark@gmail.com', 'thebutiful@gmail.com', 7),
(23, 'peterparker@gmail.com', 'thebutiful@gmail.com', 7.5),
(24, 'karmajohn@gmail.com', 'thebutiful@gmail.com', 7.5),
(25, 'ahmadkarim@gmail.com', 'thebutiful@gmail.com', 8),
(26, 'thebutiful@gmail.com', 'ahmadkarim@gmail.com', 7.5),
(27, 'tonystark@gmail.com', 'ahmadkarim@gmail.com', 8.5),
(28, 'peterparker@gmail.com', 'ahmadkarim@gmail.com', 8),
(29, 'karmajohn@gmail.com', 'ahmadkarim@gmail.com', 7.5),
(30, 'tonystark@gmail.com', 'karmajohn@gmail.com', 6),
(31, 'peterparker@gmail.com', 'karmajohn@gmail.com', 6.5),
(32, 'thebutiful@gmail.com', 'peterparker@gmail.com', 7),
(33, 'tonystark@gmail.com', 'peterparker@gmail.com', 8);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(50) NOT NULL,
  `friends` int(11) DEFAULT NULL,
  `rating` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `friends`, `rating`) VALUES
(41, 'Ahmad Karim', '9a88cbae1f472d0a44d55b660dfe0380f0b804ad2900fb0b590d8e0c60f1b735', 'ahmadkarim@gmail.com', NULL, 6.625),
(42, 'Karma John', '8a8c0c5b01a63861805e6b84877c9f0fb5c3820f22294f2208945032c09579bb', 'karmajohn@gmail.com', NULL, 7.625),
(43, 'Peter Parker', 'b1b5399bf62ecae0636bfe60a8b8464135808ccafe7d764cc9eb1127060e5891', 'peterparker@gmail.com', NULL, 6.25),
(44, 'Tony Stark', '961333c60f92024b437864eb6973cb24f4313365f60588b7692fb50b36b8545e', 'tonystark@gmail.com', NULL, 7.375),
(45, 'The Butiful', 'e594535dd79485711113af2e97556db7f92395f6dc28e192d61a8de0ce5cb9cc', 'thebutiful@gmail.com', NULL, 7.625);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_email` (`user_email`);

--
-- Indexes for table `rating`
--
ALTER TABLE `rating`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rateduser_email` (`rateduser_email`),
  ADD KEY `ratinguser_email` (`ratinguser_email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `rating`
--
ALTER TABLE `rating`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`user_email`) REFERENCES `users` (`email`);

--
-- Constraints for table `rating`
--
ALTER TABLE `rating`
  ADD CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`rateduser_email`) REFERENCES `users` (`email`),
  ADD CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`ratinguser_email`) REFERENCES `users` (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
