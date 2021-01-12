package de.kybernetik.rest

import de.kybernetik.database.pushmessages.PushMessage
import java.io.Serializable

data class PushMessageDto(
    var notification: PushNotificationDto? = null,
    var data: Map<String, Any?>? = null,
    var recipients: List<String>? = null,
    var persistent: Boolean = false
) {

    companion object {
        fun convertFromPushMessage(pushMessage: PushMessage): PushMessageDto =
            PushMessageDto(pushMessage.getBenachrichtigung(), pushMessage.getDaten(), null, null)
    }
}

data class PushNotificationDto(
    var title: String? = null,
    var body: String? = null,
    var channel: String? = null,
    var collapseId: String? = null
) : Serializable