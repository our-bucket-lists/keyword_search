# Build
```
flutter build web --no-tree-shake-icons
```

# Containerization
- Release version
```
docker build --platform linux/amd64 -t simonzhao219/keyword-search-ui:latest .
```
- Develop version
```
docker build --platform linux/amd64 -t simonzhao219/keyword-search-ui-develop:latest .
```

# Delivery
- Release version
```
docker push simonzhao219/keyword-search-ui:latest
```
- Develop version
```
docker push simonzhao219/keyword-search-ui-develop:latest
```


# Deployment
- Release version
```
docker run -d -p 80:80 -p 443:443 --name keyword-search-ui simonzhao219/keyword-search-ui
```
- Develop version
```
docker run -d -p 8080:80 -p 4433:443 --name keyword-search-ui-dev simonzhao219/keyword-search-ui-develop
```