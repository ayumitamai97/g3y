<template>
  <div
    v-if='notifications.length > 0'
    class='notification is-success'
  >
    <button
      class='delete'
      @click='closeNotification'
    />
    <div
      v-for='notification in notifications'
      :key='notification'
    >
      <p>{{ notification }}</p>
    </div>
  </div>
</template>

<script lang='ts'>
import util from '../src/util.ts'

export default {
  props: {
    successes: {
      type: Array,
      default: (): string[] => [],
    },
  },
  data(): object {
    return {
      notifications: this.successes,
    }
  },
  created(): void {
    this.closeNotification = util.closeNotification.bind(this)
  },
}
</script>
