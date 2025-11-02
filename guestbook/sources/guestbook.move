module guestbook::guestbook;

use std::string::{String, length};

const MAX_MESSAGE_LENGTH: u64 = 100;

const EInvalidMessageLength: u64 = 0;

public struct Message has store {
    sender: address,
    message: String,
}

public struct Guestbook has key {
    id: UID,
    no_of_messages: u64,
    messages: vector<Message>,
}

fun init(ctx: &mut TxContext) {
    let guestbook = Guestbook {
        id: object::new(ctx),
        no_of_messages: 0,
        messages: vector::empty<Message>(),
    };

    sui::transfer::share_object(guestbook);
}

public fun post_message(guestbook: &mut Guestbook, message: Message, ctx: &mut TxContext) {
    let length = std::string::length(&message.message);

    assert!(length <= MAX_MESSAGE_LENGTH, EInvalidMessageLength);

    guestbook.no_of_messages = guestbook.no_of_messages + 1;
    vector::push_back(&mut guestbook.messages, message);
}

public fun create_message(message: String, ctx: &mut TxContext): Message {
    let sender = ctx.sender();

    Message {
        sender,
        message,
    }
}