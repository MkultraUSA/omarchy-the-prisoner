# Sharp "Be Seeing You" lock screen (optional)

Omarchy's lock screen normally shows your wallpaper heavily blurred behind the
password field. This optional patch lets a theme supply its own lock image,
`lock-background.{png,jpg,jpeg,webp}`, which is shown **sharp**. The password
field moves to the lower part of the screen so the art stays visible. Themes
without a lock image keep the normal blurred lock.

It changes only how the lock looks: the wallpaper source, the blur, and the
field position. It does not touch password or fingerprint authentication.

## Enable

```sh
omarchy plugin clone omarchy.lock
patch -d ~/.config/omarchy/plugins/$USER.lock -p0 < extras/lock/sharp-lock-background.patch
omarchy restart shell
omarchy-shell lock preview      # look without locking; click to close
```

Omarchy officially supports cloned lock plugins: the clone inherits the
built-in lock's authentication permission.

## Disable (return to Omarchy's own lock)

```sh
omarchy plugin remove $USER.lock --yes
omarchy plugin enable omarchy.lock
omarchy restart shell
```

**Note:** a cloned lock does not receive future Omarchy updates to the lock
screen. After a major Omarchy update, disable it, re-clone, and re-apply the
patch. If `patch` reports a failure, the lock has changed upstream; keep the
built-in lock until this patch is updated.

Tested on Omarchy 4.0.4 (Quickshell).
