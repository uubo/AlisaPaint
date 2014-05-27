package com.mipt.protocol.common;

public interface InputListenerDelegate {
    public Class messageClass(short code);
    public void responseTo(Message message);
    public void setInputListener(InputListener clientListener);
}
