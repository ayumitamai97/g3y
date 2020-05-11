export default {
  async sleep(time: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, time))
  },
  closeError(): void {
    this.errors = []
  },
  closeWarning(): void {
    this.warnings = []
  },
}
