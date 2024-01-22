-- Creates the database for the relations to be created into, unspecified if this is required
CREATE DATABASE IF NOT EXISTS `Ticket Booking Database`;

-- Creating the relations
CREATE TABLE IF NOT EXISTS `Company`(
    `registrationNo` CHAR(8),
    `name` VARCHAR(255),
    `contactEmail` VARCHAR(255),
    `contactPhoneNo` CHAR(11),
    `officePostcode` VARCHAR(7),
    PRIMARY KEY(`registrationNo`),
    UNIQUE(`name`),
    UNIQUE(`contactEmail`),
    UNIQUE(`contactPhoneNo`)
);

CREATE TABLE IF NOT EXISTS `Event`(
    `eventID` INT(8) AUTO_INCREMENT,
    `name` TINYTEXT NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `location` VARCHAR(255),
    `startDate` DATE NOT NULL,
    `startTime` TIME,
    `endDate` DATE,
    `endTime` TIME,
    `companyRegNo` CHAR(8),
    PRIMARY KEY(`eventID`),
    UNIQUE(`name`),
    FOREIGN KEY(`companyRegNo`) REFERENCES `Company`(`registrationNo`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Customer`(
    `customerID` INT(8) AUTO_INCREMENT,
    `firstName` VARCHAR(255),
    `surname` VARCHAR(255),
    `email` VARCHAR(255),
    `phoneNo` CHAR(11),
    PRIMARY KEY(`customerID`),
    UNIQUE(`email`),
    UNIQUE(`phoneNo`)
);

CREATE TABLE IF NOT EXISTS `Voucher`(
    `voucherCode` VARCHAR(12),
    `discountPercentage` DECIMAL(2,2),
    `eventID` INT(8),
    PRIMARY KEY(`voucherCode`),
    FOREIGN KEY(`eventID`) REFERENCES `Event`(`eventID`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Card`(
    `cardNo` CHAR(16) NOT NULL,
    `cardType` VARCHAR(12) NOT NULL,
    `securityCode` CHAR(3) NOT NULL,
    `expiryDate` CHAR(5) CHECK (`expiryDate` RLIKE '[0-9]{2}-[0-9]{2}'),
    `cardName` TINYTEXT,
    PRIMARY KEY(`cardNo`)
);

CREATE TABLE IF NOT EXISTS `CardLink`(
    `customerID` INT(8) NOT NULL,
    `cardNo` CHAR(16) NOT NULL,
    FOREIGN KEY(`customerID`) REFERENCES `Customer`(`customerID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(`cardNo`) REFERENCES `Card`(`cardNo`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Booking`(
    `referenceNo` INT(8) AUTO_INCREMENT,
    `dOBooking` DATE DEFAULT CURRENT_DATE(),
    `tOBooking` TIME DEFAULT CURRENT_TIME(),
    `emailOrVenue` enum('e', 'v'),
    `customerID` INT(8),
    `voucherCode` VARCHAR(12) DEFAULT NULL,
    `eventID` INT(8),
    `totalPaid` FLOAT(2),
    `cardNo` CHAR(16),
    PRIMARY KEY(`referenceNo`),
    FOREIGN KEY(`customerID`) REFERENCES `Customer`(`customerID`) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY(`voucherCode`) REFERENCES `Voucher`(`voucherCode`) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY(`eventID`) REFERENCES `Event`(`eventID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(`cardNo`) REFERENCES `Card`(`cardNo`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Ticket`(
    `ticketID` INT(8) AUTO_INCREMENT,
    `ticketName` VARCHAR(255),
    `ticketPrice` FLOAT(2) DEFAULT 0.00,
    `eventID` INT(8) NOT NULL,
    `noOfTickets` INT NOT NULL,
    PRIMARY KEY(`ticketID`),
    FOREIGN KEY(`eventID`) REFERENCES `Event`(`eventID`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `TicketSold`(
    `ticketID` INT(8) NOT NULL,
    `customerID` INT(8) NOT NULL,
    `bookingRef` INT(8) NOT NULL,
    FOREIGN KEY(`ticketID`) REFERENCES `Ticket`(`ticketID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(`customerID`) REFERENCES `Customer`(`customerID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(`bookingRef`) REFERENCES `Booking`(`referenceNo`) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Populating the relations with sufficient data for each ticket_query to return a row
INSERT INTO `Company`
    VALUES
        ("27468515", "Real Food Festivals", "rff@gmail.com", "12345678910", "EX41AA"),
        ("72893035", "Real Music Festivals", "rmf@gmail.com", "01987654321", "EX42BB"),
        ("11778064", "Events Ltd", "events@hotmail.com", "01202345678", "SW472CC");

INSERT INTO `Event`(`name`, `description`, `location`, `startDate`, `startTime`, `endDate`, `endTime`, `companyRegNo`)
    VALUES
        ("Exeter Food Festival 2023", "A yearly food festival held in Exeter", "Exeter Cathedral Green", "2023-07-08", "12:00:00", "2023-07-11", "20:00:00", "27468515"),
        ("Exmouth Music Festival 2023", "A yearly music festival held in Exeter", "Exmouth Centre", "2023-07-01", "17:00:00", "2023-07-03", "23:59:59", "72893035"),
        ("Colossal", "An event that has not happened yet", "Hyde Park", "2024-03-21", "17:00:00", "2024-03-23", "23:59:59", "11778064");

INSERT INTO `Ticket`(`ticketName`, `ticketPrice`, `eventID`, `noOfTickets`)
    VALUES
        ("Adult", 5.00, (SELECT `eventID` FROM `Event` WHERE `name` = "Exeter Food Festival 2023"), 500),
        ("Child", 2.50, (SELECT `eventID` FROM `Event` WHERE `name` = "Exeter Food Festival 2023"), 250),
        ("Gold", 150.00, (SELECT `eventID` FROM `Event` WHERE `name` = "Exmouth Music Festival 2023"), 250),
        ("Silver", 100.00, (SELECT `eventID` FROM `Event` WHERE `name` = "Exmouth Music Festival 2023"), 650),
        ("Bronze", 50.00, (SELECT `eventID` FROM `Event` WHERE `name` = "Exmouth Music Festival 2023"), 1000),
        ("Standard", 47.50, (SELECT `eventID` FROM `Event` WHERE `name` = "Colossal"), 20000);

INSERT INTO `Customer`(`firstName`, `surname`, `email`, `phoneNo`)
    VALUES
        ("Joe", "Bloggs", "joebloggs@hotmail.com", "07777777777"),
        ("Ian", "Cooper", "iancooper123@btinternet.com", "01425111222"),
        ("Joe", "Smiths", "joe999smiths@outlook.com", "07472489921");

INSERT INTO `Booking`(`emailOrVenue`, `customerID`, `eventID`, `totalPaid`)
    VALUES
        ("e", (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Joe" AND `surname` = "Bloggs"), (SELECT `eventID` FROM `Event` WHERE `name` = "Exmouth Music Festival 2023"), 200.00),
        ("e", (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Joe" AND `surname` = "Smiths"), (SELECT `eventID` FROM `Event` WHERE `name` = "Colossal"), 47.50);

INSERT INTO `TicketSold` (`ticketID`, `customerID`, `bookingRef`)
    VALUES
        ((SELECT `ticketID` FROM `Ticket` `T` INNER JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID` WHERE `T`.`ticketName` = "Gold" AND `E`.`name` = "Exmouth Music Festival 2023"), (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Joe" AND `surname` = "Bloggs"), (SELECT `referenceNo` FROM `Booking` WHERE `customerID` = (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Joe" AND `surname` = "Bloggs"))),
        ((SELECT `ticketID` FROM `Ticket` `T` INNER JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID` WHERE `T`.`ticketName` = "Bronze" AND `E`.`name` = "Exmouth Music Festival 2023"), (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Joe" AND `surname` = "Bloggs"), (SELECT `referenceNo` FROM `Booking` WHERE `customerID` = (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Joe" AND `surname` = "Bloggs"))),
        ((SELECT `ticketID` FROM `Ticket` `T` INNER JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID` WHERE `T`.`ticketName` = "Standard" AND `E`.`name` = "Colossal"), (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Joe" AND `surname` = "Smiths"), (SELECT `referenceNo` FROM `Booking` WHERE `customerID` = (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Joe" AND `surname` = "Smiths")));

INSERT INTO `Card` (`cardNo`, `cardType`, `securityCode`, `expiryDate`, `cardName`)
    VALUES
        ("1234123412341234", "American Express", "999", "03-25", "Credit Card");

INSERT INTO `CardLink` (`customerID`, `cardNo`)
    VALUES
        ((SELECT `customerID` FROM `Customer` WHERE `firstName` = "Ian" AND `surname` = "Cooper"), "1234123412341234");

INSERT INTO `Voucher` (`voucherCode`, `discountPercentage`, `eventID`)
    VALUES
        ("FOOD10", 0.9, (SELECT `eventID` FROM `Event` WHERE `name` = "Exeter Food Festival 2023"));