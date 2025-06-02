<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Secretary Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .action-btn { background-color: #FF9800; color: white; padding: 10px 20px; margin: 5px; text-decoration: none; border-radius: 5px; border: none; cursor: pointer; }
        .form-section { background: #f9f9f9; padding: 20px; margin: 20px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Secretary Dashboard</h1>
        <p>Welcome, <%= session.getAttribute("username") %>!</p>
        
        <div class="form-section">
            <h3>Administrative Actions</h3>
            
            <form action="SecretaryServlet" method="post" style="display: inline;">
                <input type="hidden" name="action" value="createStudent">
                <input type="submit" value="Create Student" class="action-btn">
            </form>
            
            <form action="SecretaryServlet" method="post" style="display: inline;">
                <input type="hidden" name="action" value="createProfessor">
                <input type="submit" value="Create Professor" class="action-btn">
            </form>
            
            <form action="SecretaryServlet" method="post" style="display: inline;">
                <input type="hidden" name="action" value="createAssignment">
                <input type="submit" value="Create Assignment" class="action-btn">
            </form>
        </div>
        
        <a href="login.jsp">Logout</a>
    </div>
</body>
</html> 