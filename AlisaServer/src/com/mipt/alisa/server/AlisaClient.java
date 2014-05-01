package com.mipt.alisa.server;

import java.io.*;
import java.net.Socket;

public class AlisaClient extends Thread {

    private AlisaRoom room;
    private Socket socket;
    private InputStream in;
    private OutputStream out;

    public AlisaClient(AlisaRoom room, Socket socket)
    {
        this.room = room;
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
                        room.sendMessageFrom(this, buffer);
                    } else {
                        done = true;
                    }
                }
            }
            socket.close();
            room.removeClient(this);
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
