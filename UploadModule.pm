package UploadModule;

use nginx;
use HTTP::Body;
use IO::File;
use File::Copy;

sub handler {
    my $r = shift;

    if ($r->request_method ne "POST") {
        return HTTP_BAD_REQUEST;
    }

    return HTTP_BAD_REQUEST unless $r->has_request_body(\&post);
}

sub post {
    my $r = shift;

    my $upload_dir = $r->variable("upload_dir");

    unless ($upload_dir) {
        return error($r, HTTP_INTERNAL_SERVER_ERROR, "Upload directory not set");
    }

    my $tmp_nginx_body_file = $r->request_body_file;

    my $fh = IO::File->new($tmp_nginx_body_file, 'r') or return error($r, HTTP_INTERNAL_SERVER_ERROR, "Unable to open request body file");

    # Initialize HTTP::Body
    my $content_type = $r->header_in('Content-Type');
    my $content_length = $r->header_in('Content-Length');
    my $body = HTTP::Body->new($content_type, $content_length);

    # Read the file contents
    my $buffer;
    while (my $bytes_read = $fh->read($buffer, 1024)) {
        $body->add(substr($buffer, 0, $bytes_read));
    }

    # Get the parsed params
    my $tempname = $body->{upload}->{file}->{tempname};
    my $filename = $body->{upload}->{file}->{filename};

    unless ($filename =~ /^[a-zA-Z0-9]+\.[a-zA-Z0-9]{1,100}$/) {
	unlink $tempname;
        return error($r, HTTP_BAD_REQUEST, "Invalid filename format");
    }

    my $destination = $upload_dir . "/" . $filename;

    unless (move($tempname, $destination)) {
	unlink $tempname;
        return error($r, HTTP_INTERNAL_SERVER_ERROR, "Unable to move uploaded file");
    }

    $r->status(HTTP_CREATED);
    my $response = '{"message": "File uploaded successfully"}';
    $r->send_http_header('application/json');
    $r->print($response);
    return OK;
}

sub error {
    my ($r, $status, $message) = @_;

    $r->log_error($status, $message);

    $r->header_out('Content-Type', 'text/plain');
    $r->status($status);
    $r->send_http_header();
    $r->print("Upload has failed, see the logs");

    return OK;
}

1;
