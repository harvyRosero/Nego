# Dimensiones de la mochila
import math
length = 70.0  # cm (largo)
width = 30.0   # cm (ancho)
height = 20.0  # cm (alto)

# Incertidumbres en las dimensiones
delta_length = 1.0   # cm (incertidumbre en el largo)
delta_width = 0.1    # cm (incertidumbre en el ancho)
delta_height = 0.1   # cm (incertidumbre en el alto)

# Densidad del oro
density_gold = 19.32  # g/cm^3

# Calcular el volumen de la mochila
volume = length * width * height  # en cm^3

# Propagación de la incertidumbre en el volumen
relative_uncertainty_volume = math.sqrt((delta_length / length)**2 + (delta_width / width)**2 + (delta_height / height)**2)
delta_volume = volume * relative_uncertainty_volume

# Calcular la masa de los lingotes de oro
mass = density_gold * volume  # en g

# Propagación de la incertidumbre en la masa (solo depende del volumen en este caso)
delta_mass = mass * relative_uncertainty_volume

# Resultados
mass, delta_mass

print(mass, delta_mass)