# Object Relational Mapping (ORM)

| Key              | Value                                                                                                                                                                                                                                                                                                                                                          |
|:-----------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Course Codes** | DAT 2201, DAT 3103, BBT 3104, MCS 8104, MIT 8107, BBT 4106                                                                                                                                                                                                                                                                                                     |
| **Course Names** | DAT 2201: Database Design and SQL (Week 1-3 of 13), <br/>DAT 3103: Principles of Data Engineering (Week 1-3 of 13), <br/>BBT 3104: Advanced Database Systems (Week 7-9 of 13), <br/>MCS 8104: Database Management Systems (Week 1-3 of 13), <br/>MIT 8107: Advanced Database Systems (Week 1-3 of 13), <br/>BBT 4106: Business Intelligence I (Week 4-6 of 13) |
| **Semester**     | May to July 2026                                                                                                                                                                                                                                                                                                                                               |
| **Lecturer**     | Allan Omondi                                                                                                                                                                                                                                                                                                                                                   |
| **Contact**      | aomondi@strathmore.edu                                                                                                                                                                                                                                                                                                                                         |
| **Note**         | The lecture contains both theory and practice.<br/>This notebook forms part of the practice.<br/>It is intended for educational purpose only.<br/>Recommended citation: [BibTex](https://raw.githubusercontent.com/course-files/ObjectRelationalMapping/refs/heads/main/RecommendedCitation.bib)                                                               |

## Overall Architecture

This lab focuses on the ORM and the database only. See [https://github.com/course-files/ServingMLModels](https://github.com/course-files/ServingMLModels) for a lab that focuses on the backend.

![img.png](assets/images/OverallArchitecture.png)

## Repository Structure

```text
.
├── Docker-Compose.yaml
├── LICENSE
├── README.md
├── RecommendedCitation.bib
├── assets
│   └── images
│       ├── 1_DataGripTOSQLLite.png
│       ├── 2_CreateTableConfirmation.png
│       ├── 3_Insert_Confirmation.png
│       ├── 4_Automatic-vs-Manual-Transmission.png
│       ├── activate_venv_pycharm.png
│       ├── activate_venv_vscode.png
│       └── pexels-antonio-filigno-159809-8538296.jpg
├── container-volumes
│   ├── mysql
│   │   ├── etc-mysql
│   │   │   ├── conf.d
│   │   │   │   ├── docker.cnf
│   │   │   │   └── mysql.cnf
│   │   │   ├── my.cnf
│   │   │   ├── my.cnf.fallback
│   │   │   └── my.cnf.original
│   │   └── init-scripts
│   │       ├── 0.a.DDL_siwaka_dishes_original.sql
│   │       ├── 0.b.siwaka_dishes.png
│   │       ├── 1.a.DML_general_data.sql
│   │       ├── 1.c.DML_employee_data.sql
│   │       ├── 2.b.DML_customer_data.sql
│   │       ├── 3.b.DML_customerOrder_data.sql
│   │       ├── 4.b.DML_orderDetail_data.sql
│   │       ├── 5.b.DML_payment_data.sql
│   │       ├── 6.b.DML_customerfeedback_data.sql
│   │       ├── 7.a.DML_other_DB_objects.sql
│   │       ├── classicmodels.png
│   │       ├── classicmodels.sql
│   │       ├── dreamhome.png
│   │       └── dreamhome.sql
│   └── postgresql
│       ├── etc-postgresql
│       │   ├── pg_hba.conf
│       │   └── postgresql.conf
│       └── init-scripts
│           ├── 0.a.DDL_siwaka_dishes_original.sql
│           ├── 0.b.siwaka_dishes.png
│           ├── 1.a.DML_general_data.sql
│           ├── 1.c.DML_employee_data.sql
│           ├── 2.b.DML_customer_data.sql
│           ├── 3.b.DML_customerOrder_data.sql
│           ├── 4.b.DML_orderDetail_data.sql
│           ├── 5.b.DML_payment_data.sql
│           ├── 6.b.DML_customerfeedback_data.sql
│           ├── 7.a.DML_other_DB_objects.sql
│           ├── classicmodels.png
│           ├── classicmodels.sql
│           ├── dreamhome.png
│           └── dreamhome.sql
├── data
├── images
│   └── mysql
│       └── Dockerfile
├── lab_submission_instructions.md
├── model
├── queries
├── requirements.txt
├── setup_instructions.md
├── sql_alchemy_part1.ipynb
├── sql_alchemy_part2.ipynb
└── sql_alchemy_part3.ipynb

16 directories, 53 files
```

## Setup Instructions

- [Setup Instructions](setup_instructions.md)

## Lab Manual

Refer to the files below for more details:

1. [sql_alchemy_part1.ipynb](sql_alchemy_part1.ipynb)
2. [sql_alchemy_part2.ipynb](sql_alchemy_part2.ipynb)
3. [sql_alchemy_part3.ipynb](sql_alchemy_part3.ipynb)
4. [sql_alchemy_part4.ipynb](sql_alchemy_part4.ipynb)

## Lab Submission Instructions

- [Lab Submission Instructions](lab_submission_instructions.md)
