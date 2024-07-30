import sys

def main():
    # Print the name of the script
    print(f"Script name: {sys.argv[0]}")
    
    # Check if any arguments are passed
    if len(sys.argv) > 1:
        print("Arguments passed:")
        for i, arg in enumerate(sys.argv[1:], start=1):
            print(f"Argument {i}: {arg}")
    else:
        print("No arguments passed.")

if __name__ == "__main__":
    main()
