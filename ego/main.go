package main

import (
    "crypto/sha256"
    "fmt"
    "github.com/edgelesssys/ego/enclave"
)

func main() {
    // Generate a hash as sample data
    data := sha256.Sum256([]byte("Alex's benchmark"))

    // Generate the report
    report, err := enclave.GetRemoteReport(data[:])
    if err != nil {
        fmt.Println("Failed to generate report:", err)
        return
    }

    // Print the log 
    fmt.Println("quote size =", len(report))
    fmt.Println("DCAP generate quote successfully")
    fmt.Println("{")
    fmt.Println("  \"Type\": 3,")
    fmt.Println("  \"Attributes\": 0,")
    fmt.Printf("  \"MrEnclaveHex\": \"%X\",\n", report[48:64])
    fmt.Printf("  \"MrSignerHex\": \"%X\",\n", report[32:48])
    fmt.Printf("  \"ProductIdHex\": \"%X\",\n", report[16:32])
    fmt.Println("  \"SecurityVersion\": 1,")
    fmt.Println("  \"Attributes\": 0,")
    fmt.Printf("  \"EnclaveHeldDataHex\": \"%X\"\n", data[:])
    fmt.Println("}")

}