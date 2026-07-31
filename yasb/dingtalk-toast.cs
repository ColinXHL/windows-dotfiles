using System;
using System.IO;
using System.Security;
using Windows.Data.Xml.Dom;
using Windows.UI.Notifications;

internal static class DingTalkToast
{
    private const string AppId = "ColinXHL.DingTalkReminder";

    private static int Main()
    {
        try
        {
            string iconPath = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                "YASB",
                "dingtalk-reminder.png");
            string iconUri = SecurityElement.Escape(new Uri(iconPath).AbsoluteUri);
            string payload =
                "<toast><visual><binding template='ToastGeneric'>" +
                "<image placement='appLogoOverride' src='" + iconUri + "'/>" +
                "<text>\u65B0\u6D88\u606F\u901A\u77E5</text>" +
                "<text>\u6536\u5230\u4E00\u6761\u65B0\u6D88\u606F</text>" +
                "</binding></visual></toast>";

            XmlDocument document = new XmlDocument();
            document.LoadXml(payload);

            ToastNotification toast = new ToastNotification(document);
            toast.Tag = "dingtalk-reminder";
            toast.Group = "dingtalk";
            toast.ExpirationTime = DateTimeOffset.Now.AddHours(1);
            ToastNotificationManager.CreateToastNotifier(AppId).Show(toast);
            return 0;
        }
        catch
        {
            return 1;
        }
    }
}
