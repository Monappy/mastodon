# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  helper StreamEntriesHelper

  def mention(recipient, notification)
    @me     = recipient
    @status = notification.target_status

    I18n.with_locale(@me.user.locale || I18n.default_locale) do
      mail to: @me.user.email, subject: I18n.t('notification_mailer.mention.subject', name: @status.account.acct)
    end
  end

  def follow(recipient, notification)
    @me      = recipient
    @account = notification.from_account

    I18n.with_locale(@me.user.locale || I18n.default_locale) do
      mail to: @me.user.email, subject: I18n.t('notification_mailer.follow.subject', name: @account.acct)
    end
  end

  def favourite(recipient, notification)
    @me      = recipient
    @account = notification.from_account
    @status  = notification.target_status

    I18n.with_locale(@me.user.locale || I18n.default_locale) do
      mail to: @me.user.email, subject: I18n.t('notification_mailer.favourite.subject', name: @account.acct)
    end
  end

  def reblog(recipient, notification)
    @me      = recipient
    @account = notification.from_account
    @status  = notification.target_status

    I18n.with_locale(@me.user.locale || I18n.default_locale) do
      mail to: @me.user.email, subject: I18n.t('notification_mailer.reblog.subject', name: @account.acct)
    end
  end

  def follow_request(recipient, notification)
    @me      = recipient
    @account = notification.from_account

    I18n.with_locale(@me.user.locale || I18n.default_locale) do
      mail to: @me.user.email, subject: I18n.t('notification_mailer.follow_request.subject', name: @account.acct)
    end
  end
  
  def notify_password(recipient, password)
    @me = recipient

    I18n.with_locale(@me.user.locale || I18n.default_locale) do
      mail to: @me.user.email, subject: I18n.t('notification_mailer.notify_password.subject', password: @password)
    end
  end

  def digest(recipient, opts = {})
    @me            = recipient
    @since         = opts[:since] || @me.user.last_emailed_at || @me.user.current_sign_in_at
    @notifications = Notification.where(account: @me, activity_type: 'Mention').where('created_at > ?', @since)
    @follows_since = Notification.where(account: @me, activity_type: 'Follow').where('created_at > ?', @since).count

    return if @notifications.empty?

    I18n.with_locale(@me.user.locale || I18n.default_locale) do
      mail to: @me.user.email,
        subject: I18n.t(
          :subject,
          scope: [:notification_mailer, :digest],
          count: @notifications.size
        )
    end
  end
end
