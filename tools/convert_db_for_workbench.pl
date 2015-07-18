#########
# 
# ER図作成ツールのために、外部キーを設定するツール
#
# DB名+ _ + @filtersに設定した名前 のDBが新規作成される。
# 作成されたDBをMySQLWorkBenchなどで読み込ませる
#
# 設定されたDB内にあるテーブルに対してTRUNCATEが走るので注意。
#
#########
use strict;
use warnings;
use File::Basename;
use DBIx::Inspector;

# [名前, 対象とするテーブルのリスト(空の場合はすべてのテーブルが対象)]
my @filters = (
    'all', [],
);

my $dsn = '';

my $base_db;
if ($dsn =~ /dbname=([^;]+)/ || $dsn =~ /dbi:mysql:([^;]+)/) {
    $base_db = $1;
}
else {
    die "Can't detect dbname from $dsn";
}

$dbconfig->[0] .= ';mysql_multi_statements=1';

while (my ($name, $filter) = splice(@filters, 0, 2)) {
    create_er($app, $base_db, $name, $filter);
}

sub create_er {
    my ($app, $base_db, $name, $filter) = @_;


    my $to_db = $base_db.'_'.$name;
    warn "Creating DB $to_db\n";
    $app->db->dbh->do("CREATE DATABASE $to_db DEFAULT CHARSET=utf8");

    my $inspector = DBIx::Inspector->new(dbh => $app->db->dbh);
    my @tables = $inspector->tables();

    my %pks;
    for my $table (@tables) {
        my $table_name = $table->name;
        next if (is_excluded($filter, $table_name));

        my @pk = $table->primary_key;
        next unless @pk;
        $pks{$table_name} = $pk[0]->name;
        $app->db->dbh->do("TRUNCATE ".$table_name);

        warn "Creating TABLE $table_name\n";
        my $sth = $app->db->dbh->prepare("SHOW CREATE TABLE ".$table_name);
        $sth->execute();
        my $sql = $sth->fetchrow;
        $sth->finish;
        $app->db->dbh->do("USE $to_db;".$sql);
        $app->db->dbh->do("USE $base_db");
    }

    for my $table (keys %pks) {
        my $pk = $pks{$table};
        my $column_name = $table.'_'.$pk;

        for my $t (@tables) {
            next if (is_excluded($filter, $t->name));
            for my $column ($t->columns) {
                if ($column_name eq $column->name) {
                    my $sql = sprintf("ALTER TABLE $to_db.%s ADD FOREIGN KEY (%s) REFERENCES $to_db.%s(%s)", $t->name, $column->name, $table, $pk);
                    warn $sql . "\n";
                    $app->db->dbh->do($sql);
                }
            }
        }
    }
}

sub is_excluded {
    my ($filter, $table_name) = @_;

    if (!@$filter || grep(/^$table_name$/, @$filter)) {
        return 0;
    }

    return 1;
}
