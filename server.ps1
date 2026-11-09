param(
    [int]$Port = 8080,
    [string]$Root = $PSScriptRoot
)

$ip = [System.Net.IPAddress]::Any
$listener = New-Object System.Net.Sockets.TcpListener($ip, $Port)

try {
    $listener.Start()
} catch {
    $Port = 8081
    $listener = New-Object System.Net.Sockets.TcpListener($ip, $Port)
    $listener.Start()
}

$localIP = "127.0.0.1"
try {
    $ipConfig = ipconfig | Out-String
    if ($ipConfig -match "IPv4 Address[^\d]+([\d\.]+)") {
        $localIP = $Matches[1].Trim()
    }
} catch {}

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  LENSA Local Network Server Aktif!" -ForegroundColor Green
Write-Host "  Komputer / Laptop : http://localhost:$Port/" -ForegroundColor Cyan
Write-Host "  HP (Smartphone)   : http://${localIP}:$Port/" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Green

$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".svg"  = "image/svg+xml"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".json" = "application/json; charset=utf-8"
    ".ico"  = "image/x-icon"
}

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        $context = @{
            Client    = $client
            Root      = $Root
            MimeTypes = $mimeTypes
        }

        [System.Threading.ThreadPool]::QueueUserWorkItem([System.Threading.WaitCallback]{
            param($ctx)
            $c = $ctx.Client
            $rootDir = $ctx.Root
            $mimes = $ctx.MimeTypes

            try {
                $stream = $c.GetStream()
                $stream.ReadTimeout = 3000
                $stream.WriteTimeout = 3000

                $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::ASCII)
                $requestLine = $reader.ReadLine()
                if (-not $requestLine) { $c.Close(); return }

                # Read remaining header lines
                while ($true) {
                    $line = $reader.ReadLine()
                    if ([string]::IsNullOrWhiteSpace($line)) { break }
                }

                $parts = $requestLine.Split(' ')
                if ($parts.Length -lt 2) { $c.Close(); return }

                $method = $parts[0].ToUpper()
                if ($method -notin @("GET", "HEAD")) {
                    $resp = [System.Text.Encoding]::UTF8.GetBytes("HTTP/1.1 405 Method Not Allowed`r`nContent-Length: 0`r`nConnection: close`r`n`r`n")
                    $stream.Write($resp, 0, $resp.Length)
                    $c.Close()
                    return
                }

                $rawUrl = $parts[1]
                $qIdx = $rawUrl.IndexOf('?')
                if ($qIdx -ge 0) { $rawUrl = $rawUrl.Substring(0, $qIdx) }

                if ($rawUrl -eq "/" -or [string]::IsNullOrWhiteSpace($rawUrl)) {
                    $rawUrl = "/index.html"
                }

                $decoded = [Uri]::UnescapeDataString($rawUrl.TrimStart('/').Replace('/', [System.IO.Path]::DirectorySeparatorChar))
                $filePath = Join-Path $rootDir $decoded

                if (Test-Path $filePath -PathType Leaf) {
                    $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
                    $mime = if ($mimes.ContainsKey($ext)) { $mimes[$ext] } else { "application/octet-stream" }
                    $content = [System.IO.File]::ReadAllBytes($filePath)
                    $hdr = "HTTP/1.1 200 OK`r`n" +
                           "Content-Type: $mime`r`n" +
                           "Content-Length: $($content.Length)`r`n" +
                           "Access-Control-Allow-Origin: *`r`n" +
                           "Connection: close`r`n`r`n"
                    $hdrBytes = [System.Text.Encoding]::ASCII.GetBytes($hdr)
                    $stream.Write($hdrBytes, 0, $hdrBytes.Length)
                    if ($method -eq "GET") {
                        $stream.Write($content, 0, $content.Length)
                    }
                } else {
                    $body = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
                    $hdr = "HTTP/1.1 404 Not Found`r`n" +
                           "Content-Type: text/plain`r`n" +
                           "Content-Length: $($body.Length)`r`n" +
                           "Connection: close`r`n`r`n"
                    $hdrBytes = [System.Text.Encoding]::ASCII.GetBytes($hdr)
                    $stream.Write($hdrBytes, 0, $hdrBytes.Length)
                    if ($method -eq "GET") {
                        $stream.Write($body, 0, $body.Length)
                    }
                }
                $stream.Flush()
            } catch {
            } finally {
                $c.Close()
            }
        }, $context) | Out-Null
    }
} finally {
    $listener.Stop()
}
