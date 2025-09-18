package murach.sql;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SqlGatewayServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, 
                         HttpServletResponse response)
            throws ServletException, IOException {
        
        String sqlStatement = request.getParameter("sqlStatement");
        String sqlResult = "";
        try {
            // load the driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // get a connection to Aiven MySQL using environment variables
            String dbURL = System.getenv("DATABASE_URL") != null 
                ? System.getenv("DATABASE_URL")
                : "jdbc:mysql://mysql-3a297a68-chap12-1.i.aivencloud.com:27412/defaultdb?ssl-mode=REQUIRED&serverTimezone=UTC";
            String username = System.getenv("DATABASE_USERNAME") != null 
                ? System.getenv("DATABASE_USERNAME") 
                : "avnadmin";
            String password = System.getenv("DATABASE_PASSWORD") != null 
                ? System.getenv("DATABASE_PASSWORD") 
                : "fallback-password-not-real";
            Connection connection = DriverManager.getConnection(
                    dbURL, username, password);
            
            // create a statement
            Statement statement = connection.createStatement();
            
            // parse the SQL string
            sqlStatement = sqlStatement.trim();
            if (sqlStatement.length() >= 4) {
                String sqlType = sqlStatement.substring(0, 4).toUpperCase();
                
                // Check if it's a query that returns a result set
                if (sqlType.equals("SELE") || // SELECT
                    sqlStatement.toUpperCase().startsWith("SHOW") ||
                    sqlStatement.toUpperCase().startsWith("DESCRIBE") ||
                    sqlStatement.toUpperCase().startsWith("DESC") ||
                    sqlStatement.toUpperCase().startsWith("EXPLAIN")) {
                    
                    // create the HTML for the result set
                    ResultSet resultSet 
                            = statement.executeQuery(sqlStatement);
                    sqlResult = SQLUtil.getHtmlTable(resultSet);
                    resultSet.close();
                } else {
                    // Handle INSERT, UPDATE, DELETE, CREATE, DROP, etc.
                    int i = statement.executeUpdate(sqlStatement);
                    if (i == 0) {
                        sqlResult = "<p>The statement executed successfully.</p>";
                    } else {
                        sqlResult = "<p>The statement executed successfully.<br>"
                                + i + " row(s) affected.</p>";
                    }
                }
            } else {
                sqlResult = "<p>Please enter a valid SQL statement.</p>";
            }
            statement.close();
            connection.close();
        } catch (ClassNotFoundException e) {
            sqlResult = "<p>Error loading the database driver: <br>"
                    + e.getMessage() + "</p>";
        } catch (SQLException e) {
            sqlResult = "<p>Error executing the SQL statement: <br>"
                    + e.getMessage() + "</p>";
        }
        
        HttpSession session = request.getSession();
        session.setAttribute("sqlResult", sqlResult);
        session.setAttribute("sqlStatement", sqlStatement);
        
        // Create HTML response directly
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        
        String htmlResponse = generateHtmlResponse(sqlStatement, sqlResult);
        response.getWriter().write(htmlResponse);
    }
    
    private String generateHtmlResponse(String sqlStatement, String sqlResult) {
        return "<!DOCTYPE html>\n" +
                "<html>\n" +
                "<head>\n" +
                "    <meta charset=\"utf-8\" />\n" +
                "    <title>Murach's Java Servlets and JSP</title>\n" +
                "    <link rel=\"stylesheet\" href=\"styles/main.css\" type=\"text/css\" />\n" +
                "</head>\n" +
                "<body>\n" +
                "    <h1>The SQL Gateway</h1>\n" +
                "    <p>Enter an SQL statement and click the Execute button.</p>\n" +
                "\n" +
                "    <p><b>SQL statement:</b></p>\n" +
                "    <form action=\"sqlGateway\" method=\"post\">\n" +
                "        <textarea name=\"sqlStatement\" cols=\"60\" rows=\"8\">" + 
                (sqlStatement != null ? sqlStatement : "SHOW TABLES;") + "</textarea><br />\n" +
                "        <input type=\"submit\" value=\"Execute\" />\n" +
                "    </form>\n" +
                "\n" +
                "    <p><b>SQL result:</b></p>\n" +
                "    <div id=\"sqlResult\">\n" +
                (sqlResult != null ? sqlResult : "<!-- Results will be displayed here after form submission -->") + "\n" +
                "    </div>\n" +
                "</body>\n" +
                "</html>";
    }
}