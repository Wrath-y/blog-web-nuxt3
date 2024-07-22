<template>
    <div class="wrap">
        <div style="display: inline;position: absolute; top: 100px;left:0px">
            <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-1466336567692166"
                data-ad-slot="5695809452" data-ad-format="auto" data-full-width-responsive="true"></ins>
        </div>
        <div style="display: inline;position: absolute; top: 100px; right:0px">
            <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-1466336567692166"
                data-ad-slot="5695809452" data-ad-format="auto" data-full-width-responsive="true"></ins>
        </div>
        <div class="top"></div>
        <el-row justify="center">
            <el-col :xs="20" :sm="20" :md="20" :lg="16" :xl="12">
                <el-card v-loading="loading">
                    <div class="header">
                        <span class="header-h1"
                            :style="{ 'font-weight': 'bold', 'font-size': nowIsMobile ? '20px' : '28px' }">{{ form.title
                            }}</span>
                        <div class="post-meta">
                            <span>
                                <i class="el-icon-view"></i>
                                {{ form.hits || 0 }}热度
                            </span>
                            <span style="margin: 0 10px">
                                <i class="el-icon-edit"></i>
                                {{ form.comment_count || 0 }}条评论
                            </span>
                            <span class="tags">
                                <i class="el-icon-document"></i>
                                {{ form.tags }}
                            </span>
                            <span style="margin-left: 10px">
                                <i class="el-icon-view"></i>
                                {{ getNowFormatDate(form.create_time) }}
                            </span>
                        </div>
                    </div>
                    <div class='markdown-body' v-html="form.html"></div>

                    <ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-1466336567692166"
                        data-ad-slot="5695809452" data-ad-format="auto" data-full-width-responsive="true"></ins>
                </el-card>
                <ArticleComment />
            </el-col>

        </el-row>
    </div>
</template>

<script setup>
// import '@/assets/css/lines.css';
// import '@/assets/css/customemin.css';

const route = useRoute()
const loading = ref(false)
const form = ref({})
const nowIsMobile = ref(false)
let meta = []

const fetchData = async () => {
    loading.value = true

    const {
        data
    } = await useHttpGet("/api/article/[id]", `/api/article/${route.params.id}`, {});
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

const getNowFormatDate = (timestamp) => {
    const originalDate = new Date(timestamp);
    const year = originalDate.getFullYear();
    const month = String(originalDate.getMonth() + 1).padStart(2, '0');
    const day = String(originalDate.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}


onMounted(() => {
    googleads()
    nowIsMobile.value = isMobile()
})

useAsyncData(fetchData)

useHead({
    script: [{ src: '//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/highlight.min.js' }],
    link: [{ rel: "stylesheet", href: "https://cdn.bootcss.com/github-markdown-css/2.10.0/github-markdown.min.css" }],
    meta: meta,
})

</script>

<style scoped lang="scss">
ins.adsbygoogle[data-ad-status="unfilled"] {
    display: none !important;
}

.wrap {
    position: relative;

    .top {
        padding-top: 81px;
    }

    .header {
        margin-bottom: 20px;
        text-align: center;

        .post-meta {
            margin-bottom: 15px;
            width: 100%;
            color: #888;
            font-size: 12px;

            .tags:hover {
                color: #e67474;
                cursor: url(https://gilgamesh-10047150.cos.ap-shanghai.myqcloud.com/ayuda.cur), auto;
            }
        }
    }
}
</style>
