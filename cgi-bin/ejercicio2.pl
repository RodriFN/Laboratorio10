#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

# Creamos el cgi
my $q=CGI->new;
print $q->header('text/html; charset=UTF-8');

# Configuración de conexión con la base de datos
my $database = "prueba";
my $hostname = "mariadb2"; #nombre del contenedor
my $port     = 3307;
my $user     = "rodrigo";
my $password = "12345";

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, 'rodrigo', 'tu_contraseña_segura', {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
}) or die "<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";

# Consulta
my $sth = $dbh->prepare("SELECT actor_id, nombre FROM actores WHERE actor_id >= 8");
$sth->execute();

# HTML
print <<'HTML';
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/style.css">
    <title>Ejercicio 2</title>
</head>
<body>
    <h1>Actores con ID >= 8</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
        </tr>
HTML

while (my @row = $sth->fetchrow_array) {
    print "<tr><td>$row[0]</td><td>$row[1]</td></tr>";
}

print <<'HTML';
    </table>
    <a href="/index.html">Volver al inicio</a>
</body>
</html>
HTML

$sth->finish();
$dbh->disconnect();
