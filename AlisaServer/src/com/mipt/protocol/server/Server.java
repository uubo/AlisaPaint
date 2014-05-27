package com.mipt.protocol.server;

import com.mipt.protocol.common.*;

import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Vlad on 18.05.14.
 */
public class Server extends Thread {

    private int PORT = 21022;
    private Class delegateClass;
    private List<InputListener> clients = new ArrayList<InputListener>();

    public Server(Class delegateClass, int port) {
        super();
        this.delegateClass = delegateClass;
        this.PORT = port;
    }

    public void run() {
        try {
            ServerSocket serverSocket = new ServerSocket(PORT);
            for (;;) {
                Socket incoming = serverSocket.accept();

                InputListener clientListener = new InputListener(incoming, newDelegate());
                clientListener.start();

                clients.add(clientListener);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<InputListener> getClients() {
        return clients;
    }

    public void removeClient(InputListener clientListener) {
        clients.remove(clientListener);
    }

    private InputListenerDelegate newDelegate() {
        try {
            Constructor constructor = delegateClass.getConstructor(new Class[]{Server.class});
            return (InputListenerDelegate)constructor.newInstance(this);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }
}
