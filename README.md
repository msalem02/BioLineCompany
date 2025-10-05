# BioLine Company Management System  
### Full-Stack Web Application for Integrated Business Operations, Analytics, and Data Management  

---

## 1. Overview

**BioLineCompany** is a comprehensive **enterprise management web application** built using the **Flask framework** and **MySQL** as the backend database.  
The system is designed to automate daily business operations and provide a centralized platform for managing all major organizational processes — including employees, departments, products, inventory, sales, customers, and suppliers — while generating **business intelligence dashboards** for performance monitoring and decision-making.

This project reflects advanced knowledge in **database engineering, backend development, and data-driven web application design**. It was developed to simulate a real company’s workflow and reporting needs with **modular architecture**, **responsive UI**, and **secure database interactions**.

---

## 2. Objectives

- Build a full-stack web platform for managing company operations and data visualization.  
- Design a normalized MySQL relational schema with referential integrity.  
- Integrate Flask backend with dynamic front-end templates (Jinja2).  
- Implement secure CRUD operations across multiple modules.  
- Visualize company performance using analytical dashboards (Chart.js, Matplotlib).  
- Ensure system extensibility for future features like AI analytics or API integration.  

---

## 3. Key Features

| Feature | Description |
|----------|-------------|
| **Company Management** | Manage company info, departments, branches, and their associated entities. |
| **Employee Management** | Register, edit, and track employees by department, role, and salary. |
| **Department Management** | Define departments, assign managers, and maintain employee hierarchies. |
| **Product & Inventory Management** | Store product information, prices, stock levels, and supplier links. |
| **Sales System** | Record and manage customer transactions and revenue tracking. |
| **Customer & Supplier Records** | Maintain detailed logs of customer and supplier interactions. |
| **Analytics Dashboard** | Visualize KPIs like revenue growth, top products, and employee performance. |
| **Authentication & Security** | Secure login system using Flask sessions and input validation. |
| **Error Handling & Logging** | Centralized error catching and event logging for stability. |

---

## 4. System Architecture

The **BioLineCompany architecture** follows a **Model-View-Controller (MVC)** pattern integrated within the Flask micro-framework.

```
+---------------------+       +------------------+       +---------------------+
|     Web Client      | <----> |     Flask App    | <----> |     MySQL Server     |
| (Browser, Bootstrap)|       | (Controller +    |       | (Data Storage Layer) |
|                     |       |  Logic Layer)    |       |                     |
+---------------------+       +------------------+       +---------------------+
```

**Workflow Summary:**  
1. User interacts with the web interface.  
2. Flask receives the request, processes it, and interacts with the database.  
3. Data is fetched, processed, and rendered dynamically using **Jinja2 templates**.  
4. Charts and analytics are displayed through **Chart.js** and **Matplotlib** visualizations.  

---

## 5. Technologies Used

| Layer | Technologies |
|--------|---------------|
| **Frontend** | HTML5, CSS3, Bootstrap 5, JavaScript, Jinja2 |
| **Backend** | Python (Flask Framework) |
| **Database** | MySQL (Relational DB with Foreign Keys and Constraints) |
| **Visualization** | Chart.js, Matplotlib, Pandas |
| **Tools** | MySQL Workbench, VS Code, Git, GitHub |
| **Testing/Debugging** | Postman, Flask Debug Toolbar |

---

## 6. Database Design

The **MySQL database** is designed with **referential integrity and normalization (3NF)** to ensure data consistency.

### 6.1 ER Diagram (Conceptual Overview)
```
Company (1) ───< Department (N)
Department (1) ───< Employee (N)
Product (1) ───< Sales (N)
Customer (1) ───< Sales (N)
Supplier (1) ───< Product (N)
```

### 6.2 Core Tables

**Company Table**
| Field | Type | Description |
|--------|------|-------------|
| company_id | INT (PK) | Unique identifier for each company |
| name | VARCHAR(100) | Company name |
| address | TEXT | Headquarters address |
| total_revenue | DECIMAL(12,2) | Aggregated revenue |

**Employee Table**
| Field | Type | Description |
|--------|------|-------------|
| emp_id | INT (PK) | Employee unique ID |
| name | VARCHAR(100) | Full name |
| position | VARCHAR(50) | Job title |
| salary | DECIMAL(10,2) | Monthly salary |
| dept_id | INT (FK) | Linked to Department table |

**Sales Table**
| Field | Type | Description |
|--------|------|-------------|
| sale_id | INT (PK) | Unique sale transaction ID |
| product_id | INT (FK) | Product sold |
| customer_id | INT (FK) | Customer who purchased |
| quantity | INT | Units sold |
| total_price | DECIMAL(10,2) | Sale amount |
| sale_date | DATE | Transaction date |

---

## 7. Project Structure

```
BioLineCompany/
│
├── app.py                     # Main Flask application entry point
├── config.py                  # Database configuration (host, user, password, db)
├── static/                    # Static resources (CSS, JS, images)
│   ├── css/
│   ├── js/
│   └── img/
├── templates/                 # Frontend templates (Jinja2 + HTML)
│   ├── index.html
│   ├── dashboard.html
│   ├── employees.html
│   ├── departments.html
│   ├── products.html
│   ├── customers.html
│   ├── suppliers.html
│   └── login.html
├── database/
│   └── schema.sql             # SQL file for creating all tables
├── reports/                   # Generated analytical visualizations
├── logs/                      # Server logs and event traces
├── requirements.txt           # Python dependencies
└── README.md                  # Project documentation
```

---

## 8. Installation & Setup

### 8.1 Clone Repository
```bash
git clone https://github.com/msalem02/BioLineCompany.git
cd BioLineCompany
```

### 8.2 Create and Activate Virtual Environment
```bash
python -m venv venv
venv\Scripts ctivate  # Windows
source venv/bin/activate  # Mac/Linux
```

### 8.3 Install Required Packages
```bash
pip install -r requirements.txt
```

### 8.4 Configure Database
Edit `config.py` with your local MySQL credentials:
```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'your_password',
    'database': 'bioline_company'
}
```

### 8.5 Initialize Database Schema
In MySQL:
```sql
SOURCE database/schema.sql;
```

### 8.6 Run the Application
```bash
python app.py
```
Then open [http://127.0.0.1:5000](http://127.0.0.1:5000) in your browser.

---

## 9. Dashboard and Visualization

The **Business Intelligence Dashboard** summarizes key company metrics such as:  
- Revenue Trends (Line Charts)  
- Product Sales Distribution (Pie/Bar Charts)  
- Employee Count by Department (Bar Charts)  
- Monthly Growth Rate Visualization  

These charts are implemented using **Chart.js** and **Matplotlib**, dynamically fed by backend MySQL queries.  

*(Recommended screenshots: `/static/img/dashboard.png`, `/static/img/revenue_chart.png`)*

---

## 10. Example Use Case Flow

### Scenario: New Sale Transaction
1. Admin logs into the system.  
2. Customer and Product data are retrieved dynamically.  
3. User enters sale details and confirms transaction.  
4. Sale entry is inserted into the database and inventory is updated.  
5. Dashboard metrics are automatically refreshed to reflect updated revenue.

---

## 11. Security Measures

- Session-based user authentication  
- Password hashing (optional future feature)  
- Form validation and sanitization  
- Prevention of SQL injection using Flask-MySQLdb parameterized queries  
- Restricted admin access for sensitive modules  

---

## 12. Future Enhancements

- Implement user role management (Admin, Manager, Employee).  
- Deploy system on cloud (AWS, Render, or Heroku).  
- Integrate RESTful API for mobile applications.  
- Add machine learning-based **sales forecasting** module.  
- Implement automated email/SMS alerts for low-stock products.  
- Add exportable reports (PDF/Excel) via Flask-WeasyPrint.  

---

## 13. Learning Outcomes

By developing this system, the following key competencies were achieved:

- Advanced database normalization and design principles.  
- Backend integration using Flask ORM and SQL connectors.  
- REST-like routing and server-side rendering using Jinja2.  
- Dynamic data visualization and real-time updates.  
- Deployment-ready full-stack project management.  

---

## 14. Author

Mohammed Salem  
Email: salemmohamad926@gmail.com  
LinkedIn: https://www.linkedin.com/in/msalem02  
GitHub: https://github.com/msalem02  

---

## 15. License

This project is licensed under the **MIT License**.  
You may freely use, modify, and distribute it for educational or professional purposes.  
See the LICENSE file for full details.

---

## 16. Acknowledgements

- Flask, Chart.js, and MySQL open-source communities  
- Birzeit University — Department of Computer Engineering  
- Mentors, peers, and course instructors for continuous guidance  
- Online developer resources and documentation (Flask, Bootstrap, SQLAlchemy)  

---

## 17. Version History

| Version | Date | Description |
|----------|------|-------------|
| 1.0 | September 2024 | Initial Flask + MySQL implementation |
| 1.1 | October 2024 | Added Sales and Analytics modules |
| 1.2 | November 2024 | Enhanced dashboard and improved database indexing |
| 2.0 | December 2024 | Final production-ready version with reports and BI features |

---
