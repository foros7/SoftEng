<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Professor Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .action-btn { background-color: #2196F3; color: white; padding: 10px 20px; margin: 5px; text-decoration: none; border-radius: 5px; border: none; cursor: pointer; }
        .form-section { background: #f9f9f9; padding: 20px; margin: 20px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Professor Dashboard</h1>
        <p>Welcome, <%= session.getAttribute("username") %>!</p>
        
        <div class="form-section">
            <h3>Professor Actions</h3>
            
            <form action="ProfessorServlet" method="post" style="display: inline;">
                <input type="hidden" name="action" value="createAppointments">
                <input type="submit" value="Create Appointments" class="action-btn">
            </form>
            
            <form action="ProfessorServlet" method="post" style="display: inline;">
                <input type="hidden" name="action" value="markAssignment">
                <input type="submit" value="Mark Assignments" class="action-btn">
            </form>
            
            <form action="ProfessorServlet" method="post" style="display: inline;">
                <input type="hidden" name="action" value="getReports">
                <input type="submit" value="Generate Reports" class="action-btn">
            </form>
        </div>
        
        <a href="login.jsp">Logout</a>
    </div>
</body>
</html> 