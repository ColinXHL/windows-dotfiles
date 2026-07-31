using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Security;
using Windows.Data.Xml.Dom;
using Windows.UI.Notifications;

internal static class DingTalkToast
{
    private const string AppId = "ColinXHL.DingTalkReminder";
    private const string Tag = "dingtalk-reminder";
    private const string Group = "dingtalk";
    private const string DingTalkExe = @"C:\Program Files (x86)\DingDing\main\current\DingTalk.exe";

    [DllImport("user32.dll")]
    private static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    private static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    private static int Main(string[] args)
    {
        try
        {
            if (args.Length > 0 && args[0].Equals("clear", StringComparison.OrdinalIgnoreCase))
            {
                ToastNotificationManager.History.Remove(Tag, Group, AppId);
                return 0;
            }

            if (args.Length > 0 && args[0].Equals("open", StringComparison.OrdinalIgnoreCase))
            {
                OpenDingTalk();
                return 0;
            }

            string iconPath = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                "YASB",
                "dingtalk-reminder.png");
            string iconUri = SecurityElement.Escape(new Uri(iconPath).AbsoluteUri);
            string payload =
                "<toast activationType='protocol' launch='dingtalk-reminder:'>" +
                "<visual><binding template='ToastGeneric'>" +
                "<image placement='appLogoOverride' src='" + iconUri + "'/>" +
                "<text>\u65B0\u6D88\u606F\u901A\u77E5</text>" +
                "<text>\u6536\u5230\u4E00\u6761\u65B0\u6D88\u606F</text>" +
                "</binding></visual></toast>";

            XmlDocument document = new XmlDocument();
            document.LoadXml(payload);

            ToastNotification toast = new ToastNotification(document);
            toast.Tag = Tag;
            toast.Group = Group;
            toast.ExpirationTime = DateTimeOffset.Now.AddHours(1);
            ToastNotificationManager.CreateToastNotifier(AppId).Show(toast);
            return 0;
        }
        catch
        {
            return 1;
        }
    }

    private static void OpenDingTalk()
    {
        foreach (Process process in Process.GetProcessesByName("DingTalk"))
        {
            if (process.MainWindowHandle == IntPtr.Zero)
                continue;

            ShowWindowAsync(process.MainWindowHandle, 9);
            SetForegroundWindow(process.MainWindowHandle);
            return;
        }

        Process.Start(DingTalkExe);
    }
}
