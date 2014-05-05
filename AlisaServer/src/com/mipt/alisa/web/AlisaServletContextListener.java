package com.mipt.alisa.web;

import com.mipt.alisa.socketserver.AlisaServer;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;


public class AlisaServletContextListener implements ServletContextListener
{
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        ServletContext context = servletContextEvent.getServletContext();

        AlisaServer server = new AlisaServer();
        server.start();

        context.setAttribute("AlisaServer", server);
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
