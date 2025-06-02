<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>404 - Page Not Found</title>
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
                <h1 class="text-warning mb-4">404 - Page Not Found</h1>
                <p class="mb-4">The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Return to Login</a>
            </div>
        </div>
    </body>
</html> 