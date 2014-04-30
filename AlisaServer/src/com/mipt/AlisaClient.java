package com.mipt;

import java.io.*;
import java.net.Socket;

public class AlisaClient extends Thread {

    private AlisaServer server;
    private Socket socket;
    private InputStream in;
    private OutputStream out;

    public AlisaClient(AlisaServer server, Socket socket)
    {
        this.server = server;
        this.socket = socket;
    }

    public void run()
    {
        try
        {
            in = socket.getInputStream();
            out = socket.getOutputStream();

            boolean done = false;
            while (!done) {
                int bytesAvailable = in.available();
                if (bytesAvailable > 0) {
                    byte[] buffer = new byte[bytesAvailable];
                    if (in.read(buffer) != -1) {
                        server.send(buffer, this);
                    } else {
                        done = true;
                    }
                }
            }
            socket.close();
            server.removeClient(this);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void send(byte[] buffer)
    {
        try {
            out.write(buffer);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
