# resty-container

A Container for/based-on OpenResty with OAuth/Openidc support to protect some ressources

### Politique de gestion des branches

Trois branches principales sont utilisées pour construire ce projet:

- **master**, branche principale de développement, sans publication d'image docker
- **test**, utilisée pour certains développements nécessitant de débrancher certaines phases du build
- **production**, utilisée pour la publication des images docker "latest"

Les versions officielles (hors _latest_) sont produites à partir d'un **tag** au format _X.Y.Z_
