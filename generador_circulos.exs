defmodule GeneradorCirculos do


  def generar_svg(filename, centro_x, centro_y, radio_inicial, cantidad, reduccion) do
    ancho = centro_x * 2
    alto = centro_y * 2

    # Generamos la lista de círculos recursivamente
    elementos_svg = generar_circulos_rec(centro_x, centro_y, radio_inicial, cantidad, reduccion, [])

    # Creamos la estructura completa del documento SVG
    contenido_svg = """
    <svg xmlns="http://www.w3.org/2000/svg" width="#{ancho}" height="#{alto}" viewBox="0 0 #{ancho} #{alto}">
      <!-- Fondo oscuro opcional para resaltar los círculos -->
      <rect width="100%" height="100%" fill="#111827" />
      #{Enum.join(elementos_svg, "\n  ")}
    </svg>
    """

    # Guardamos en el archivo
    File.write!(filename, contenido_svg)
    IO.puts("Archivo SVG generado exitosamente en: #{filename}")
  end

  # Funciones Recursivas
  # CASO BASE 1: Se dibujaron todos los círculos solicitados
  defp generar_circulos_rec(_cx, _cy, _radio, 0, _reduccion, acumulador) do
    # Invertimos para mantener el orden correcto en el SVG (de mayor a menor)
    Enum.reverse(acumulador)
  end

  # CASO BASE 2: El radio es menor o igual a cero (evita radios negativos)
  defp generar_circulos_rec(_cx, _cy, radio, _faltan, _reduccion, acumulador) when radio <= 0 do
    Enum.reverse(acumulador)
  end

  # PASO RECURSIVO: Genera un círculo y llama recursivamente con el radio reducido
  defp generar_circulos_rec(cx, cy, radio, faltan, reduccion, acumulador) do
    # Variamos el color según el radio para hacer la figura más atractiva
    stroke_color = seleccionar_color(faltan)

    # Creamos el elemento XML del círculo
    circulo_xml = """
    <circle cx="#{cx}" cy="#{cy}" r="#{radio}" fill="none" stroke="#{stroke_color}" stroke-width="2" />
    """

    # Llamada recursiva reduciendo el radio y decrementando el contador
    generar_circulos_rec(
      cx,
      cy,
      radio - reduccion,
      faltan - 1,
      reduccion,
      [circulo_xml | acumulador]
    )
  end

  # Función auxiliar para alternar o asignar colores
  defp seleccionar_color(indice) do
    colores = ["#3B82F6",
               "#8B5CF6",
               "#EC4899",
               "#10B981",
               "#F59E0B"]
    Enum.at(colores, rem(indice, length(colores)))
  end
end

# Configuración del usuario:
centro_x = 700
centro_y = 300
radio_inicial = 50
cantidad_circulos = 6
reduccion_radio = 10

# Llamada al programa
GeneradorCirculos.generar_svg(
  "circulos.svg",
  centro_x,
  centro_y,
  radio_inicial,
  cantidad_circulos,
  reduccion_radio
)
