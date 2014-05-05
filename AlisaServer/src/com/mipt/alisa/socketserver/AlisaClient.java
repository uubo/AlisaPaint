package com.mipt.alisa.socketserver;

import java.io.*;
import java.net.Socket;

public class AlisaClient extends Thread {

    private String login;

    private AlisaServer server;
    private AlisaRoom room;
    private Socket socket;
    private InputStream in;
    private OutputStream out;

    private boolean authorized = false;

    public AlisaClient(AlisaRoom room, Socket socket)
    {
        this.room = room;
        this.socket = socket;
    }

    public void run()
    {
        System.out.println("AlisaServer: Client thread started");
        try
        {
            out = new DataOutputStream(socket.getOutputStream());
            in = new DataInputStream(socket.getInputStream());

            boolean done = false;
            while (!done) {
                int bytesAvailable = in.available();
                if (bytesAvailable > 0) {
                    byte[] buffer = new byte[bytesAvailable];
                    if (in.read(buffer) != -1) {
//                        if (!authorized) {
//                            login = new String(buffer);
//                            room = server.defineClientsRoom(this);
//                            authorized = true;
//                            System.out.printf("AlisaServer: Client %s authorized\n", login);
//                        } else {
                            room.sendMessageFrom(this, buffer);
//                        }
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

    public AlisaRoom getRoom() {
        return room;
    }

    public void setRoom(AlisaRoom room) {
        this.room = room;
    }

    public String getLogin() {
        return login;
    }
}
