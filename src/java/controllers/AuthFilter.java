package controllers;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//import javax.servlet.Filter;
//import javax.servlet.FilterChain;
//import javax.servlet.ServletException;
//import javax.servlet.ServletRequest;
//import javax.servlet.ServletResponse;
//import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import java.io.IOException;

@WebFilter("/*") // Jaga semua path
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

String path = httpRequest.getRequestURI()
        .substring(httpRequest.getContextPath().length());

// Allow static resources
if (path.matches(".*\\.(css|js|png|jpg|jpeg|gif|svg|webp)$") ||
    path.startsWith("/uploads/") ||
    path.startsWith("/img/")) {

    chain.doFilter(request, response);
    return;
}


        boolean loggedIn = (session != null && session.getAttribute("userName") != null);
        String userRole = (loggedIn) ? (String) session.getAttribute("userRole") : "";

        boolean isLoginRegister = path.endsWith("login.jsp") || path.endsWith("register.jsp") 
                                 || path.endsWith("LoginServlet") || path.endsWith("RegisterServlet");

        if (loggedIn) {
            // Proteksi folder admin
            if (path.startsWith("/admin/") && !"admin".equalsIgnoreCase(userRole)) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home.jsp");
                return;
            }
            chain.doFilter(request, response);
        } else if (isLoginRegister) {
            chain.doFilter(request, response);
        } else {
            // Jika belum login dan coba akses halaman lain, tendang ke login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        }
    }
}