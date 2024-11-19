<!DOCTYPE html>
<html lang="en">
<head>
	<title>DoughnutDen - Staff Portal</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="icon" href="images/Doughnut-Icon.png" type="image/png" />
    <style>
        .headerBanner {
            padding: 20px;
            text-align: center;
        }
        .portal-container {
            margin: 50px auto;
            padding: 20px;
            width: 50%;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .portal-container h1 {
            color: #f99f9b;
            margin-bottom: 20px;
        }
        .portal-container a {
            display: block;
            margin: 10px 0;
            padding: 10px;
            text-decoration: none;
            color: white;
            background-color: #f99f9b;
            border-radius: 5px;
            font-size: 16px;
        }
        .portal-container a:hover {
            background-color: #d97a75;
        }
    </style>
</head>
<body>
	<header class="headerBanner">
		<h1 class="headerMain" style="display: flex; justify-content: center; align-items: center; text-decoration: none;">
			<a href="Menu.jsp"> 
				<img src="images/Doughnut-Icon.png" style=" width: 50px;" />
			 	Doughnut Den
			</a>
		</h1>
	</header>

    <div class="portal-container">
        <h1>Staff Portal</h1>
        <a href="MenuEdit.jsp">Edit Menu</a>
        <a href="TrayEdit.jsp">Edit Tray</a>
        <a href="TransactionEdit.jsp">Edit Transactions</a>
        <a href="Report.jsp">Generate Reports</a>
    </div>
</body>
</html>