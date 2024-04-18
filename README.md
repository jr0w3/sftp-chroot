# SFTP User Creation Script

This script is designed to automate the creation of SFTP users on a Linux system. It sets up chrooted environments for users, restricts them to SFTP access only, and generates random passwords for added security.

## Usage

1. Clone this repository or download the script file.
2. Optionally, modify the `sftproot` variable in the script to change the directory where user chroot folders will be stored.
3. Make sure you have root privileges to execute the script.
4. Run the script with the desired username as an argument:
    ```bash
    sudo ./sftp-chroot.sh UserName
    ```

## Contributions

Contributions to this script are welcome! If you have any suggestions for improvements, bug fixes, or additional features, feel free to open an issue or submit a pull request. Your input is valuable in making this script more robust and user-friendly.

## How to Contribute

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License

This script is licensed under the [MIT License](LICENSE).
