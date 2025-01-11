#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_ADDRESSES 10000 // Adjust as needed for large files

// Global list of processed addresses
char processedAddresses[MAX_ADDRESSES][16];
int addressCount = 0;

// Helper to check if an address is already processed
bool isAddressProcessed(const char* address)
{
    for (int i = 0; i < addressCount; i++)
    {
        if (strcmp(processedAddresses[i], address) == 0)
        {
            return true; // Address already processed
        }
    }
    return false;
}

// Add a new address to the processed list
void addAddress(const char* address)
{
    if (addressCount < MAX_ADDRESSES)
    {
        strncpy(processedAddresses[addressCount], address, sizeof(processedAddresses[addressCount]) - 1);
        processedAddresses[addressCount][sizeof(processedAddresses[addressCount]) - 1] = '\0'; // Null-terminate
        addressCount++;
    }
}

void convertLine(char* line, FILE* outputFile)
{
    char* context;
    char* prefix = strtok_r(line, " ", &context);
    char* address = strtok_r(NULL, " ", &context);
    char* label = strtok_r(NULL, " \n\t", &context);

    if (prefix != NULL && address != NULL && label != NULL)
    {
        // Remove leading dot and sanitize the label
        if (label[0] == '.')
        {
            label++;
        }

        // Check if the address is already processed
        if (!isAddressProcessed(address))
        {
            fprintf(outputFile, "$%s#%s#\n", address, label);
            addAddress(address); // Mark the address as processed
        }
        else
        {
            //printf("Skipping duplicate address: %s (label: %s)\n", address, label);
        }
    }
    else
    {
        printf("Skipping line, couldn't parse: prefix=%s, address=%s, label=%s\n",
               prefix ? prefix : "NULL",
               address ? address : "NULL",
               label ? label : "NULL");
    }
}

int main(int argc, char* argv[])
{
    if (argc < 3)
    {
        fprintf(stderr, "Usage: %s inputfile outputfile\n", argv[0]);
        return 1;
    }

    FILE* inputFile = fopen(argv[1], "r");
    if (inputFile == 0)
    {
        perror("Error opening input file");
        return 1;
    }

    FILE* outputFile = fopen(argv[2], "w");
    if (outputFile == 0)
    {
        perror("Error opening output file");
        fclose(inputFile);
        return 1;
    }

    char line[256]; // Adjust the buffer size as needed
    
    while (fgets(line, sizeof(line), inputFile))
    {
        // We expect every line to start with "al"
        if (strstr(line, "al") == line)
        {
            convertLine(line, outputFile);
        }
        else
        {
            // Debugging output to see which lines are being skipped
            printf("Skipping line (not a valid format): %s", line);
        }
    }
    
    fclose(inputFile);
    fclose(outputFile);

    return 0;
}