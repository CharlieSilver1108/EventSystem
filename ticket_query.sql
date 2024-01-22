-- Question 1
SELECT
    `E`.`name`,
    `E`.`description`,
    `E`.`location`,
    `E`.`startDate`,
    `E`.`startTime`,
    `E`.`endDate`,
    `E`.`endTime`,
    `T`.`ticketName`,
    `T`.`noOfTickets`
FROM
    `Event` `E`
RIGHT JOIN `Ticket` `T` ON
    `E`.`eventID` = `T`.`eventID`
HAVING
    `E`.`name` = "Exeter Food Festival 2023";


-- Question 2
SELECT
    `name`,
    `startDate`,
    `startTime`,
    `endTime`,
    `description`
FROM
    `Event`
WHERE
    `startDate` BETWEEN '2023-07-01' AND '2023-07-10';


-- Question 3
SELECT
    `E`.`name`,
    `T`.`ticketName`,
    `T`.`ticketPrice`,
    (`T`.`noOftickets` - IFNULL(
        (SELECT
            COUNT(`TS`.`customerID`)
        FROM
            `TicketSold` `TS`
        INNER JOIN `Ticket` `T` ON
            `TS`.`ticketID` = `T`.`ticketID`
        INNER JOIN `Event` `E` ON
            `T`.`eventID` = `E`.`eventID`
        WHERE
            `E`.`name` = "Exmouth Music Festival 2023" AND `T`.`ticketName` = "Bronze"
        GROUP BY
            (`TS`.`ticketID`)
        ), 0)
    ) AS `ticketsAvailable`
FROM
    `Event` `E`
INNER JOIN `Ticket` `T` ON
    `E`.`eventID` = `T`.`eventID`
WHERE
    `E`.`name` = "Exmouth Music Festival 2023" AND `T`.`ticketName` = "Bronze";


-- Question 4
SELECT
    `E`.`name`,
    CONCAT_WS(" ", `C`.`firstName`, `C`.`surname`) AS `customerName`,
    `T`.`ticketName`,
    COUNT(`TS`.`ticketID`) AS noOfTickets
FROM
    `TicketSold` `TS`
LEFT JOIN `Ticket` `T` ON
    `TS`.`ticketID` = `T`.`ticketID`
LEFT JOIN `Event` `E` ON
    `T`.`eventID` = `E`.`eventID`
LEFT JOIN `Customer` `C` ON
    `TS`.`customerID` = `C`.`customerID`
WHERE
    `E`.`name` = "Exmouth Music Festival 2023" AND `T`.`ticketName` = "Gold"
GROUP BY
    (`C`.`customerID`);


-- Question 5
SELECT
    `E`.`name`,
    COUNT(`TS`.`ticketID`) AS `ticketsSold`
FROM
    `Event` `E`
LEFT JOIN `Ticket` `T` ON
    `E`.`eventID` = `T`.`eventID`
LEFT JOIN `TicketSold` `TS` ON
    `T`.`ticketID` = `TS`.`ticketID`
GROUP BY
    (`E`.`name`)
ORDER BY
    `ticketsSold` DESC;


-- Question 6
SELECT
    `B`.`referenceNo`,
    CONCAT_WS(" ", `C`.`firstName`, `C`.`surname`) AS `customerName`,
    `B`.`tOBooking`,
    `E`.`name`,
    `B`.`emailOrVenue` AS `deliveryOption`,
    `T`.`ticketName`,
    COUNT(`TS`.`ticketID`) AS `noOfTickets`,
    (COUNT(`TS`.`ticketID`) * `T`.`ticketPrice` * IFNULL((SELECT `discountPercentage` FROM `Voucher` `V` INNER JOIN `Booking` `B` ON `V`.`voucherCode` = `B`.`voucherCode`), 1.00)) AS `total Paid`
FROM
    `Booking` `B`
LEFT JOIN `Customer` `C` ON
    `B`.`customerID` = `C`.`customerID`
LEFT JOIN `TicketSold` `TS` ON
    `B`.`referenceNo` = `TS`.`bookingRef`
LEFT JOIN `Ticket` `T` ON
    `TS`.`ticketID` = `T`.`ticketID`
LEFT JOIN `Event` `E` ON
    `T`.`eventID` = `E`.`eventID`
GROUP BY
    (`T`.`ticketName`);


-- Question 7
SELECT
    `E`.`name`,
    SUM(`B`.`totalPaid`) as `totalIncome`
FROM
    `Event` `E`
LEFT JOIN `Booking` `B` ON
    `E`.`eventID` = `B`.`eventID`
GROUP BY
    (`E`.`name`)
ORDER BY
    `totalIncome` DESC LIMIT 1;