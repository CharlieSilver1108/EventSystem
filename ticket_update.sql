-- Question 1
UPDATE `Ticket`
SET `noOfTickets` = `noOfTickets` + 100
WHERE `eventID` = (SELECT `eventID` FROM `Event` WHERE `name` = "Exeter Food Festival 2023") AND `ticketName` = "Adult";


-- Question 2
INSERT INTO `Booking` (`emailOrVenue`, `customerID`, `voucherCode`, `eventID`, `totalPaid`, `cardNo`)
    VALUES
        ("e",
        (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Ian" AND `surname` = "Cooper"),
        ("FOOD10"),
        (SELECT `eventID` FROM `Event` WHERE `name` = "Exeter Music Festival 2023"),
        ((2 * (SELECT `ticketPrice` FROM `Ticket` `T` INNER JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID` WHERE `E`.`name` = "Exeter Food Festival 2023" AND `T`.`ticketName` = "Adult") + (SELECT `ticketPrice` FROM `Ticket` `T` INNER JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID` WHERE `E`.`name` = "Exeter Music Festival 2023" AND `T`.`ticketName` = "Child")) * (SELECT `discountPercentage` FROM `Voucher` WHERE `voucherCode` = "FOOD10")),
        (SELECT `C`.`cardNo` as `cardLinkNo` FROM `Card` `C` INNER JOIN `CardLink` `CL` ON `C`.`cardNo` = `CL`.`cardNo` INNER JOIN `Customer` `Cu` ON `CL`.`customerID` = `Cu`.`customerID` WHERE `Cu`.`firstName` = "Ian" AND `Cu`.`surname` = "Cooper" AND `C`.`cardName` = "Credit Card")
        );

INSERT INTO `ticketSold` (`ticketID`, `customerID`, `bookingRef`)
    VALUES
        ((SELECT `ticketID` FROM `Ticket` `T` INNER JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID` WHERE `E`.`name` = "Exeter Food Festival 2023" AND `T`.`ticketName` = "Adult"),
        (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Ian" AND `surname` = "Cooper"),
        (SELECT `referenceNo` FROM `Booking` WHERE `customerID` = (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Ian" AND `surname` = "Cooper"))
        ),
        ((SELECT `ticketID` FROM `Ticket` `T` INNER JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID` WHERE `E`.`name` = "Exeter Food Festival 2023" AND `T`.`ticketName` = "Adult"),
        (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Ian" AND `surname` = "Cooper"),
        (SELECT `referenceNo` FROM `Booking` WHERE `customerID` = (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Ian" AND `surname` = "Cooper"))
        ),
        ((SELECT `ticketID` FROM `Ticket` `T` INNER JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID` WHERE `E`.`name` = "Exeter Food Festival 2023" AND `T`.`ticketName` = "Child"),
        (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Ian" AND `surname` = "Cooper"),
        (SELECT `referenceNo` FROM `Booking` WHERE `customerID` = (SELECT `customerID` FROM `Customer` WHERE `firstName` = "Ian" AND `surname` = "Cooper"))
        );


-- Question 3, how am I supposed to be given the booking ID other than by searching for it with his name?
DELETE `TS` FROM `TicketSold` `TS`
JOIN `Ticket` `T` ON `TS`.`ticketID` = `T`.`ticketID`
JOIN `Event` `E` ON `T`.`eventID` = `E`.`eventID`
JOIN `Customer` `C` ON `TS`.`customerID` = `C`.`customerID`
WHERE `E`.`startDate` > CURRENT_DATE() AND `C`.`firstName` = "Joe" AND `C`.`surname` = "Smiths";

DELETE `B` FROM `Booking` `B`
JOIN `Event` `E` ON `B`.`eventID` = `E`.`eventID`
JOIN `Customer` `C` ON `B`.`customerID` = `C`.`customerID`
WHERE `E`.`startDate` > CURRENT_DATE() AND `C`.`firstName` = "Joe" AND `C`.`surname` = "Smiths";


-- Question 4
INSERT INTO `Voucher` (`voucherCode`, `discountPercentage`, `eventID`)
    VALUES
        ("SUMMER20", 0.8, (SELECT `eventID` FROM `Event` WHERE `name` = "Exmouth Music Festival 2023"));