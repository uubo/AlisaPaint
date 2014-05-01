package com.mipt.alisa.web;

import com.mipt.alisa.socketserver.AlisaServer;

import javax.servlet.ServletException;

public class AlisaServlet extends javax.servlet.http.HttpServlet
{
    @Override
    public void init() throws ServletException {
        super.init();
        AlisaServer server = new AlisaServer();
        server.start();
    }
}