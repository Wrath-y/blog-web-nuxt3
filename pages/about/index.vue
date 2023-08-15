<template>
    <div class="wrap">
        <div class="top"></div>
        <el-card v-loading="loading">
            <div v-html="form.html"></div>
        </el-card>
    </div>
</template>

<script setup>

const loading = ref(false)
const form = ref({})
let meta = []

const fetchData = async () => {
    loading.value = true

    const {
        data
    } = await useHttpGet("/api/article/2", `/api/article/2`, {});
    if (data.value) {
        form.value = data.value
        if (form.value.article_seo) {
            meta.push({ name: 'title', content: form.value.article_seo.title })
            meta.push({ name: 'keywords', content: form.value.article_seo.keywords })
            meta.push({ name: 'description', content: form.value.article_seo.description })
        }
    }
    loading.value = false
}

useAsyncData(fetchData)

useHead({
    script: [{ src: '//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/highlight.min.js' }],
    link: [{ rel: "stylesheet", href: "https://cdn.bootcss.com/github-markdown-css/2.10.0/github-markdown.min.css" }],
    meta: meta,
})
</script>

<style scoped lang="scss">
.wrap {
    width: 50%;
    margin: auto;

    .top {
        padding-top: 81px;
    }
}
</style>

