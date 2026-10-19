## 7.1 ¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?

Podría ver la contraseña original del usuario, ya que está almacenada como texto claro. Esto representa un riesgo de seguridad porque podría utilizarla para acceder a la cuenta.

## 7.3 Generar una representación no reversible

**¿Son iguales los resultados?**

No, los resultados son diferentes aunque se utilice la misma contraseña.

**Si no son iguales, ¿por qué?**

Porque cada vez que se utiliza `gen_salt()`, se genera una sal aleatoria que produce un hash diferente.

**¿Qué función cumple `gen_salt()`?**

Genera una sal aleatoria que se utiliza para crear el hash de una contraseña, haciendo más difícil que se puedan identificar contraseñas iguales a partir de sus hashes.

**¿Qué función cumple `crypt()`?**

Genera un hash de la contraseña utilizando un algoritmo y una sal. También permite comprobar si una contraseña coincide con el hash almacenado.

**¿Esto es cifrado reversible?**

No, es un proceso de hash no reversible, por lo que no se puede recuperar directamente la contraseña original a partir del hash.

## 7.5 Verificar una contraseña

**¿Qué resultado obtuviste con la contraseña correcta?**

El resultado fue `true`, porque la contraseña ingresada coincide con la contraseña almacenada en forma de hash.

**¿Qué resultado obtuviste con la contraseña incorrecta?**

El resultado fue `false`, porque la contraseña ingresada no coincide con la contraseña original.

**¿Por qué no es necesario recuperar la contraseña original?**

Porque se puede comprobar la contraseña ingresada comparándola con el hash almacenado, sin necesidad de conocer ni recuperar la contraseña original.

**¿Por qué un hash no debe confundirse con cifrado?**

Porque el hash es una representación no reversible de los datos, mientras que el cifrado permite recuperar la información original mediante una clave de descifrado.

