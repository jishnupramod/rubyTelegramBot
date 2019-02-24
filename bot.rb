require 'telegram_bot'
token = '709950422:AAHWZCLWu5caFzHYRF4q8pW-rFvZ0xBVYik'
bot = TelegramBot.new(token: token)

def guess()
    return rand(1..100)
end

def check(com, num)
    if(com == num)
        return 1
    elsif(num < com)
        return 2
    elsif(num > com)
        return 3
    end
end

bot.get_updates(fail_silently: true) do |message|
    puts "@#{message.from.username}: #{message.text}"
    command = message.get_command_for(bot)

    message.reply do |reply|
        case command
        when /start/i
            reply.text = "All I can do is say hello and play guessing game.
                        \nTry the /greet command or /play command"
        when /hello/i
            reply.text = "All I can do is say hello and play guessing game.
                        \nTry the /greet command or /play command"
        when /greet/i
            reply.text = "Hello, #{message.from.first_name} ! "
        when /play/i
            chance = 1
            com = guess()
            puts "Assigned number is #{com}."
            reply.text = "I have guessed a random number between 1 and 100.\
                            Try to catch me... Hehe !!"
            reply.send_with(bot)
            bot.get_updates(fail_silently: true) do |message|
                if((1..100).include? message.text.to_i)
                    puts "number assigned."
                    res = check(com, message.text.to_i)
                end
                if(res == 1)
                    reply.text = "Hurraay! You guessed it right...\n /play again or /bye for now
                                    \n You guessed it in #{chance} chance#{chance==1?'':'s'}"
                    break
                elsif(res == 2)
                    reply.text = "You guessed a smaller number. Try a higher one..."
                    chance += 1
                    puts "You guessed #{message.text}"
                    reply.send_with(bot)
                elsif(res == 3)
                    reply.text = "You guessed a higher number. Try a smaller one..."
                    chance += 1
                    puts "You guessed #{message.text}"
                    reply.send_with(bot)
                else
                    reply.text = "You are supposed to guess a number.
                                    \nDon't play around with me !"
                    reply.send_with(bot)
                end
            end
        when /bye/i
            reply.text = "Bye #{message.from.first_name}. See you later!"
        else
            reply.text = "I have no idea what #{message.text} means !"

        end
        puts "Sending #{reply.text.inspect} to @#{message.from.username}"
        reply.send_with(bot)
    end
end
