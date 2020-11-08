# Lupa Pona

Lupa Pona serves the local directory as a Gemini site.

It's a super simple server: it just serves the current directory. I use Phoebe
myself, for Gemini hosting. It's a wiki, not just a file server.

**Table of Contents**

- [Dependencies](#dependencies)
- [Quickstart](#quickstart)
- [Troubleshooting](#troubleshooting)
- [Options](#options)
- [Running Lupa Pona as a Daemon](#running-lupa-pona-as-a-daemon)
- [Using systemd](#using-systemd)
- [Privacy](#privacy)

## Dependencies

Perl libraries you need to install if you want to run Lupa Pona:

- [IO::Socket::INET6](https://metacpan.org/pod/IO%3A%3ASocket%3A%3AINET6), or `libio-socket-inet6-perl`
- [IO::Socket::SSL](https://metacpan.org/pod/IO%3A%3ASocket%3A%3ASSL), or `libio-socket-ssl-perl`
- [File::Slurper](https://metacpan.org/pod/File%3A%3ASlurper), or `libfile-slurper-perl`
- [Modern::Perl](https://metacpan.org/pod/Modern%3A%3APerl), or `libmodern-perl-perl`
- [Net::Server](https://metacpan.org/pod/Net%3A%3AServer), or `libnet-server-perl`
- [URI::Escape](https://metacpan.org/pod/URI%3A%3AEscape), or `liburi-escape-xs-perl`

## Quickstart

Since Lupa Pona traffic is encrypted, we need to generate a
certificate and a key. These are both stored in PEM files. To create
your own copies of these files (and you should!), use "make cert" if
you have a copy of the Makefile. If you don't, use this:

    openssl req -new -x509 -newkey ec \
    -pkeyopt ec_paramgen_curve:prime256v1 \
    -days 1825 -nodes -out cert.pem -keyout key.pem

Answer all the questions with "." except for the one about the Common Name.
There, answer "localhost" while you're still testing things. Later, use your own
domain name.

This creates a certificate and a private key, both of them unencrypted, using
eliptic curves of a particular kind, valid for five years.

You should have three files, now: `lupa-pona`, `cert.pem`, and
`key.pem`. That's enough to get started! Start the server:

    perl lupa-pona

This starts the server in the foreground, for `gemini://localhost:1965`. If it
aborts, see the ["Troubleshooting"](#troubleshooting) section below. If it runs, open your
favourite Gemini client and test it, or open another terminal and test it:

    echo gemini://localhost \
      | openssl s_client --quiet --connect localhost:1965 2>/dev/null

You should see a Gemini page starting with the following:

    20 text/gemini; charset=UTF-8
    Welcome to Lupa Pona!

Success!! 😀 🚀🚀

## Troubleshooting

🔥 **Cannot connect to SSL port 1965 on 127.0.0.1 \[No such file or directory\]**
🔥 Perhaps your [Net::Server::Proto::SSL](https://metacpan.org/pod/Net%3A%3AServer%3A%3AProto%3A%3ASSL) module is too old?

🔥 **SSL\_cert\_file cert.pem can't be used: No such file or directory**
🔥 Perhaps you're missing the certificate (`cert.pem`) or key file
(`key.pem`). _Generate your own_ using the Makefile: `make cert`
should do it.

## Options

Lupa Pona uses [Net::Server](https://metacpan.org/pod/Net%3A%3AServer) in the background, which has a ton
options. Let's try to focus on the options you might want to use right
away.

Here's the documentation for the most useful options:

- `--host` is the hostname to serve; the default is `localhost` – you
      probably want to pick the name of your machine, if it is reachable from
      the Internet
- `--port` is the port to use; the default is 1965
- `--log_level` is the log level to use, 0 is quiet, 1 is errors, 2 is
      warnings, 3 is info, and 4 is debug; the default is 2

## Running Lupa Pona as a Daemon

If you want to start Lupa Pona as a daemon, the following options come
in handy:

- `--setsid` makes sure Lupa Pona runs as a daemon in the background
- `--pid_file` is the file where the process id (pid) gets written once the
      server starts up; this is useful if you run the server in the background
      and you need to kill it
- `--log_file` is the file to write logs into; the default is to write log
      output to the standard error (stderr)
- `--user` and `--group` might come in handy if you start Lupa Pona
      using a different user

## Using systemd

In this case, we don't want to daemonize the process. Systemd is going to handle
that for us. There's more documentation [available
online](https://www.freedesktop.org/software/systemd/man/systemd.service.html).

You could create a specific user:

    sudo adduser --disabled-login --disabled-password lupa-pona

Copy Lupa Pona to `/home/lupa-pona/lupa-pona`.

Basically, this is the template for our service:

    [Unit]
    Description=Lupa Pona
    After=network.target
    [Service]
    Type=simple
    WorkingDirectory=/home/lupa-pona
    ExecStart=/home/lupa-pona/lupa-pona
    Restart=always
    User=lupa-pona
    Group=lupa-pona
    [Install]
    WantedBy=multi-user.target

Save this as `lupa-pona.service`, and then link it:

    sudo ln -s /home/lupa-pona/lupa-pona.service /etc/systemd/system/

Reload systemd:

    sudo systemctl daemon-reload

Start Lupa Pona:

    sudo systemctl start lupa-pona

Check the log output:

    sudo journalctl --unit lupa-pona

All the files in `/home/lupa-pona` are going to be served, if the `lupa-pona`
user can read them.

## Privacy

If you increase the log level, the server will produce more output, including
information about the connections happening, like `2020/06/29-15:35:59 CONNECT
SSL Peer: "[::1]:52730" Local: "[::1]:1965"` and the like (in this case `::1`
is my local address so that isn't too useful but it could also be your visitor's
IP numbers, in which case you will need to tell them about it using in order to
comply with the
[GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation).
