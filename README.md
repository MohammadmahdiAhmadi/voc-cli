# voc-cli

voc-cli is a command-line tool for translating selected text and save that to Your [Voc Account](https://t.me/botvoc_bot) using shortcut keys.

## Features

- Translate selected text and save that to your Voc account.
- Set custom shortcut keys for translation and pronunciation.
- 107 languages supporting.

## Installation

Follow these steps to install voc-cli on your Linux system:

1. **Clone the Repository:**
```bash
git clone git@github.com:MohammadmahdiAhmadi/voc-cli.git
cd voc-cli
```

2. **Run the Setup Script:**
```bash
chmod +x setup.sh
./setup.sh
```
This script will guide you through the installation process, prompt you for necessary information, and install required dependencies.

3. **Usage:**

- Select text and press `Alt+S` to translate and save.
- Select text and press `Alt+Q` to translate without saving.
- Select text and press `Alt+V` to listen to the pronunciation.
- Run `voc-cli` in the terminal to access voc-cli settings.

## Configuration Management

To configure voc-cli, run the following command:
```bash
voc-cli
```

This will display the following menu:
```bash
Choose an option:
1. Modify language code
2. Modify api token
3. Set new shortcut keys
4. Delete shortcut keys
5. Uninstall Voc
6. Exit
Enter your choice: 
```

Choose an option by entering the corresponding number (from 1 to 6). After selecting an option, you can use the functionalities as described below:

1. **Modify Language Code**

   This option allows you to change the language code used for translation.

2. **Modify API Token**

   Use this option to update your API token received from the Voc telegram bot.

3. **Set New Shortcut Keys**

   Customize shortcut keys for translation and pronunciation. Ensure that the keys you choose are not in use by other applications.

4. **Delete Shortcut Keys**

   Delete previously configured shortcut keys.

5. **Uninstall voc-cli**

   Remove voc-cli and all related files from your system.

6. **Exit**

   Exit the configuration management menu.

## Acknowledgments

This project makes use of [translate-shell](https://github.com/soimort/translate-shell) for translation capabilities on Linux. We would like to express our thanks to the translate-shell team for their excellent work.

---

Thank you for using voc-cli! If you have any questions or feedback, please contact me at [mm.ahmadi0101@gmail.com](mailto:mm.ahmadi0101@gmail.com)
