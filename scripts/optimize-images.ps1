Add-Type -AssemblyName System.Drawing

function Save-OptimizedJpeg {
  param(
    [string]$Source,
    [string]$Destination,
    [int]$MaxWidth,
    [int]$Quality = 82
  )

  $sourceImage = [System.Drawing.Image]::FromFile((Join-Path $PSScriptRoot "..\\$Source"))
  try {
    $scale = [Math]::Min([double]1, ([double]$MaxWidth) / ([double]$sourceImage.Width))
    $width = [int][Math]::Round($sourceImage.Width * $scale)
    $height = [int][Math]::Round($sourceImage.Height * $scale)
    $bitmap = [System.Drawing.Bitmap]::new([int]$width, [int]$height)
    try {
      $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
      try {
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.DrawImage($sourceImage, 0, 0, $width, $height)
      } finally { $graphics.Dispose() }
      $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
      $parameters = New-Object System.Drawing.Imaging.EncoderParameters(1)
      $parameters.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$Quality)
      $bitmap.Save((Join-Path $PSScriptRoot "..\\$Destination"), $encoder, $parameters)
      $parameters.Dispose()
    } finally { $bitmap.Dispose() }
  } finally { $sourceImage.Dispose() }
}

function Save-OptimizedPng {
  param([string]$Source, [string]$Destination, [int]$MaxWidth)
  $sourceImage = [System.Drawing.Image]::FromFile((Join-Path $PSScriptRoot "..\\$Source"))
  try {
    $scale = [Math]::Min([double]1, ([double]$MaxWidth) / ([double]$sourceImage.Width))
    $width = [int][Math]::Round($sourceImage.Width * $scale)
    $height = [int][Math]::Round($sourceImage.Height * $scale)
    $bitmap = [System.Drawing.Bitmap]::new([int]$width, [int]$height)
    try {
      $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
      try {
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($sourceImage, 0, 0, $width, $height)
      } finally { $graphics.Dispose() }
      $bitmap.Save((Join-Path $PSScriptRoot "..\\$Destination"), [System.Drawing.Imaging.ImageFormat]::Png)
    } finally { $bitmap.Dispose() }
  } finally { $sourceImage.Dispose() }
}

New-Item -ItemType Directory -Force -Path (Join-Path $PSScriptRoot '..\\assets') | Out-Null
Save-OptimizedJpeg 'Plano de Fundo Hero.png' 'assets/hero-background.jpg' 1672 80
Save-OptimizedJpeg 'Mulher Sênior Elegante em Poltrona Moderna.png' 'assets/hero-portrait.jpg' 980 82
Save-OptimizedJpeg 'Retrato acolhedor de mulher madura na biblioteca.png' 'assets/about-portrait.jpg' 900 82
Save-OptimizedJpeg 'Retrato Profissional na Biblioteca Aconchegante.png' 'assets/approach-portrait.jpg' 900 82
Save-OptimizedJpeg 'Conversa Acolhedora na Sala de Terapia.png' 'assets/online-therapy.jpg' 960 82
Save-OptimizedPng 'Logo sem fundo.png' 'assets/logo.png' 500
