package rest

data class PushMessageDto (
        var notification: PushNotificationDto? = null,
        var data: Map<String, String>? = null,
        var topic: String? = null,
        var recipients: List<String>? = null
)

data class PushNotificationDto(
        var title: String? = null,
        var body: String? = null
)

