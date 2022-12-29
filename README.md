# solviolin-flutter
```
# .github/workflows/flutter.yml

echo "${{ secrets.KEYSTORE }}" | base64 --decode > ./android/app/key.jks

echo storeFile=./key.jks > ./android/key.properties
echo keyAlias=\${{ secrets.KEY_ALIAS }} >> ./android/key.properties
echo storePassword=\${{ secrets.PASSWORD }} >> ./android/key.properties
echo keyPassword=\${{ secrets.PASSWORD }} >> ./android/key.properties
```
