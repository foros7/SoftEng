<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>500 - Internal Server Error</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .error-container {
                text-align: center;
                padding: 40px;
                background-color: white;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="error-container">
                <h1 class="text-danger mb-4">500 - Internal Server Error</h1>
                <p class="mb-4">Sorry, something went wrong on our end. Please try again later.</p>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Return to Login</a>
            </div>
        </div>
    </body>
</html> 