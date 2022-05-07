#!/usr/bin/env bash

pushd

# install adminer

cd /usr/share/nginx
chown -R nginx:nginx html
chmod g+s html
chmod u+s html
mkdir html/adminer
cd html/adminer
curl -4 -o '/usr/share/nginx/html/adminer/adminer-4.8.1-en.php' -L 'https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-en.php'
curl -4 -o '/usr/share/nginx/html/adminer/adminer.css' -L 'https://raw.githubusercontent.com/vrana/adminer/master/designs/flat/adminer.css'
# ln -s adminer-4.8.1-en.php adminer.php
cat > '/usr/share/nginx/html/adminer/adminer.php' << EOF
<?php
function adminer_object() {
    // required to run any plugin
    include_once "./plugins/plugin.php";

    // autoloader
    foreach (glob("plugins/*.php") as \$filename) {
        include_once "./\$filename";
    }

    \$plugins = array(
        // specify enabled plugins here
        new AdminerDumpMarkdown,
    );

    /* It is possible to combine customization and plugins:
    class AdminerCustomization extends AdminerPlugin {
    }
    return new AdminerCustomization(\$plugins);
    */

    return new AdminerPlugin(\$plugins);
}

// include original Adminer or Adminer Editor
include "./adminer-4.8.1-en.php";
?>
EOF
mkdir plugins
cd plugins
curl -4 -o 'plugin.php' -L 'https://raw.githubusercontent.com/vrana/adminer/master/plugins/plugin.php'
curl -4 -o 'dump-markdown.php' -L 'https://raw.githubusercontent.com/fthiella/adminer-plugin-dump-markdown/master/dump-markdown.php'

popd
