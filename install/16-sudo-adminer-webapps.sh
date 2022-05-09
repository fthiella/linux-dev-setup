#!/usr/bin/env bash

set -e

# install adminer

dest=/usr/share/nginx/apps/

pushd /usr/share/nginx

mkdir -m=6775 -p apps/adminer
chown -R nginx:nginx apps

cd apps/adminer
curl -4 -o "$dest/adminer/adminer-4.8.1-en.php" -L 'https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-en.php'
curl -4 -o "$dest/adminer/adminer.css" -L 'https://raw.githubusercontent.com/vrana/adminer/master/designs/flat/adminer.css'
cat > "$dest/index.php" << EOF
<?php
function adminer_object() {
    include_once "./plugins/plugin.php";
    foreach (glob("plugins/*.php") as \$filename) {
        include_once "./\$filename";
    }

    \$plugins = array(
        // specify enabled plugins here
        new AdminerDumpMarkdown,
    );

    return new AdminerPlugin(\$plugins);
}

include "./adminer-4.8.1-en.php";
?>
EOF
mkdir plugins
cd plugins
curl -4 -o 'plugin.php' -L 'https://raw.githubusercontent.com/vrana/adminer/master/plugins/plugin.php'
curl -4 -o 'dump-markdown.php' -L 'https://raw.githubusercontent.com/fthiella/adminer-plugin-dump-markdown/master/dump-markdown.php'

cd /usr/share/nginx/apps
mkdir -m=6775 -p flask
chown -R nginx:nginx flask

popd

cp config/flask/main.py $dest/flask/
cp config/flask/wsgi.py $dest/flask/
cp config/flask/gunicorn.service /etc/systemd/system

cp config/adminer.conf /etc/nginx/default.d/
cp config/flask/flask.conf /etc/nginx/default.d/

systemctl enable gunicorn
systemctl start gunicorn
systemctl reload nginx