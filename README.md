### About:
This is an individual project, completed as an assignment for a Year 2 Module at the University of Exeter, using databases. It was completed using Microsoft Visual Studio Code and MySQL.

### The Project Description:
In this assignment, you are required to conduct an analysis and design a database for an online ticket booking system. This online ticket booking website offers services that enable customers to book tickets online for events such as circuses, concerts, shows, etc.
\nThe system will store details of each event. Some events have only one ticket price, while others offer a range of prices (e.g., adult ticket price and child ticket price). Each event has a fixed number of tickets that can be sold for each ticket type. Seats are not numbered.
\nWhen a customer decides to purchase tickets, they will enter their basic information, select the chosen event, and specify the quantity of each type of ticket required. The system will save the booking with a unique reference code.
\nEach event may offer several voucher codes, each with a unique code and a discount. If a customer enters a valid code, their payment will be automatically discounted. Customers can choose to have tickets sent by email or pick them up at the venue just before the performance.
\nA booking is considered successful only if the customer has paid in full using a credit card or debit card. The website will display the total amount to be charged, and the customer will need to enter their card type (e.g., Visa, Mastercard or Amex), the card number, the security code, and the card's expiry date. For simplicity, you may assume that the customer is the cardholder. Card details will be stored in the booking system’s database for future reference.
Customers have the option to cancel their booking and receive a full refund before the event takes place. Once the event has started, the booking for that event cannot be cancelled.

## Other:
The Entity-Relationship diagram, Relational Model, and the justifications for my design choices are documented within the ticket_design.pdf file

The project is coded entirely in SQL
