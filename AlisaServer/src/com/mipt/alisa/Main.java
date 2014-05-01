package com.mipt.alisa;

import com.mipt.alisa.server.AlisaServer;

public class Main {

    public static void main(String[] args)
    {
        AlisaServer server = new AlisaServer();
        server.start();
    }
}
